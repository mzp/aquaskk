/* -*- ObjC -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2008 Tomotaka SUWA <t.suwa@mac.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/

#import <AquaSKKIM/BlacklistApps.h>
#import <AquaSKKIM/SKKServer.h>
#import <AquaSKKIM/SKKPreProcessor.h>
#import <AquaSKKCore/SKKRomanKanaConverter.h>
#import <AquaSKKCore/SKKBackEnd.h>
#import <AquaSKKCore/SKKCommonDictionary.h>
#import <AquaSKKCore/SKKAutoUpdateDictionary.h>
#import <AquaSKKCore/SKKProxyDictionary.h>
#import <AquaSKKCore/SKKGadgetDictionary.h>
#import <AquaSKKCore/SKKLocalUserDictionary.h>
#import <AquaSKKCore/SKKDistributedUserDictionary.h>
#import <AquaSKKCore/SKKDictionaryFactory.h>
#import <AquaSKKService/SKKConstVars.h>
// #import <AquaSKKIM/SKKPythonRunner.h>
#import <AquaSKKIM/MacKotoeriDictionary.h>
#import <AquaSKKCore/skkserv.h>
#import <AquaSKKUI/InputModeWindow.h>
#import <AquaSKKService/AISDefaultServerConfiguration.h>
#import <os/log.h>
#include <signal.h>

static os_log_t serverLog = os_log_create("com.aquaskk.inputmethods", "server");

namespace {
    // 順番の入れ替えは禁止(追加のみ)
    struct DictionaryTypes {
        enum {
            Common,
            AutoUpdate,
            Proxy,
            Kotoeri,
            Gadget,
            CommonUTF8,
        };
    };

    NSString* DictionaryNames[] = {
        @"SKK 辞書(EUC-JP)",
        @"SKK 辞書(自動ダウンロード)",
        @"skkserv 辞書",
        @"ことえり辞書",
        @"プログラム辞書",
        @"SKK 辞書(UTF-8)"
    };

    const struct {
        int mode;
        NSString* name;
    } InputModeIcons[] = {
        { (int)SKKInputMode::HirakanaInputMode,		@"AquaSKK-Hirakana" },
        { (int)SKKInputMode::KatakanaInputMode,		@"AquaSKK-Katakana" },
        { (int)SKKInputMode::Jisx0201KanaInputMode,	@"AquaSKK-Jisx0201Kana" },
        { (int)SKKInputMode::AsciiInputMode,		@"AquaSKK-Ascii" },
        { (int)SKKInputMode::Jisx0208LatinInputMode,	@"AquaSKK-Jisx0208Latin" },
        { 0,				0 }
    };
}

static void terminate(int) {
    [NSApp terminate:nil];
}

@interface SKKServer (Local)
- (void)prepareSignalHandler;
- (void)prepareDirectory;
- (void)prepareConnection;
- (void)prepareUserDefaults;
- (void)prepareDictionarySet;
- (void)prepareDictionary;
- (void)prepareBlacklistApps;
- (id)newIMKServer;

- (void)initializeInputModeIcons;
- (BOOL)fileExistsAtPath:(NSString*)path;
- (void)createDirectory:(NSString*)path;
- (NSString*)pathForSystemResource:(NSString*)path;
- (NSString*)pathForUserResource:(NSString*)path;
- (NSString*)pathForResource:(NSString*)path;
@end

@implementation SKKServer

- (void)awakeFromNib {
    [self _start];

    imkserver_ = [self newIMKServer];
}

- (void)_start {
    [self _startWithConfiguration:[[AISDefaultServerConfiguration alloc] init]];
}

- (void)_startWithConfiguration:(id<AISServerConfiguration>)configuration {
    configuration_ = configuration;
    skkserv_ = 0;

    [self prepareSignalHandler];
    [self prepareDirectory];
    [self prepareConnection];
    [self prepareUserDefaults];
    [self prepareDictionarySet];
    [self prepareDictionary];
    [self prepareBlacklistApps];

    [self reloadBlacklistApps];
    [self reloadDictionarySet];
    [self reloadUserDefaults];
    [self reloadComponents];
}

- (void)reloadBlacklistApps {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    NSArray* array = [NSMutableArray arrayWithContentsOfFile:SKKFilePaths::BlacklistApps];
    if(array == nil) {
        os_log_error(serverLog, "can't read BlacklistApps.plist");
    }
    [[BlacklistApps sharedManager] load: array];
}

- (void)reloadUserDefaults {
    bool flag;

    delete skkserv_;

    os_log_info(serverLog, "loading UserDefaults ...");

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* prefs = [[NSDictionary dictionaryWithContentsOfFile:SKKFilePaths::UserDefaults] retain];

    // force update userdeafults
    [defaults setPersistentDomain:prefs forName:[[NSBundle mainBundle] bundleIdentifier]];

    [prefs release];

    if([defaults boolForKey:SKKUserDefaultKeys::enable_skkserv] == YES) {
        skkserv_ = new skkserv([defaults integerForKey:SKKUserDefaultKeys::skkserv_port],
                               [defaults boolForKey:SKKUserDefaultKeys::skkserv_localonly] == YES);
    }

    flag = [defaults boolForKey:SKKUserDefaultKeys::use_numeric_conversion] == YES;
    SKKBackEnd::theInstance().UseNumericConversion(flag);

    flag = [defaults boolForKey:SKKUserDefaultKeys::enable_extended_completion] == YES;
    SKKBackEnd::theInstance().EnableExtendedCompletion(flag);

    flag = [defaults boolForKey:SKKUserDefaultKeys::enable_private_mode] == YES;
    SKKBackEnd::theInstance().EnablePrivateMode(flag);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    int length = [defaults integerForKey:SKKUserDefaultKeys::minimum_completion_length];
#pragma clang diagnostic pop
    SKKBackEnd::theInstance().SetMinimumCompletionLength(length);
}

- (void)reloadDictionarySet {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSString* userDictionary = [configuration_ userDictionaryPath];
    NSArray* array = [configuration_ systemDictionaries];

    SKKDictionaryKeyContainer keys;
    NSEnumerator* enumerator = [array objectEnumerator];
    
    while(NSDictionary* entry = [enumerator nextObject]) {
        NSNumber* active = [entry valueForKey:SKKDictionarySetKeys::active];

        if([active boolValue] == YES) {
            NSNumber* type = [entry valueForKey:SKKDictionarySetKeys::type];
            NSString* location = [entry valueForKey:SKKDictionarySetKeys::location];

            if(location && [location length] > 0) {
                location = [location stringByExpandingTildeInPath];

                // 自動更新辞書の場合
                if([type intValue] == DictionaryTypes::AutoUpdate) {
                    NSString* file = [location lastPathComponent];
                    NSString* path = [NSString stringWithFormat:@"%@ %@/%@ %@",
                                               [defaults stringForKey:SKKUserDefaultKeys::openlab_host],
                                               [defaults stringForKey:SKKUserDefaultKeys::openlab_path],
                                               location,
                                               [self pathForUserResource:file]];
                    location = path;
                }
            } else {
                location = @"[location was not specified]";
            }

            os_log_info(serverLog, "loading %@ (%@)", DictionaryNames[[type intValue]], location);
            keys.push_back(SKKDictionaryKey([type intValue], [location UTF8String]));
        }
    }

#if 1
    SKKBackEnd::theInstance().Initialize(userDictionary == nil ? "" : [userDictionary UTF8String], keys);
#else
    SKKUserDictionary* dictionary = 0;

    if([defaults boolForKey:SKKUserDefaultKeys::enable_skkdap] == YES) {
        NSString* port = [defaults stringForKey:SKKUserDefaultKeys::skkdap_port];

        SKKPythonRunner runner;

        runner.Run("");

        dictionary = new SKKDistributedUserDictionary();
        dictionary->Initialize([port UTF8String]);
    } else {
        NSString* userDictionary = [defaults stringForKey:SKKUserDefaultKeys::user_dictionary_path];
        userDictionary = [userDictionary stringByExpandingTildeInPath];

        dictionary = new SKKLocalUserDictionary();
        dictionary->Initialize([userDictionary UTF8String]);
    }
    
    SKKBackEnd::theInstance().Initialize(dictionary, keys);
#endif
}

- (void)reloadComponents {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    NSString* tmp;

    tmp = [self pathForResource:@"keymap.conf"];
    SKKPreProcessor::theInstance().Initialize([tmp UTF8String]);

    tmp = [self pathForResource:@"kana-rule.conf"];
    SKKRomanKanaConverter::theInstance().Initialize([tmp UTF8String]);

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSArray* subRules = [defaults arrayForKey:SKKUserDefaultKeys::sub_rules];
    for(NSString* path in subRules) {
        os_log_info(serverLog, "loading SubRule: %@", path);
        SKKRomanKanaConverter::theInstance().Patch([path UTF8String]);
    }

    NSArray* subKeymaps = [defaults arrayForKey:SKKUserDefaultKeys::sub_keymaps];
    for(NSString* path in subKeymaps) {
        os_log_info(serverLog, "loading SubKeyMap: %@", path);
        SKKPreProcessor::theInstance().Patch([path UTF8String]);
    }

    [self initializeInputModeIcons];
}

- (NSArray*)createDictionaryTypes {
    int order[] = {
        DictionaryTypes::Common,
        DictionaryTypes::CommonUTF8,
        DictionaryTypes::AutoUpdate,
        DictionaryTypes::Proxy,
        DictionaryTypes::Kotoeri,
        DictionaryTypes::Gadget,
        0xff
    };
    NSMutableArray* types = [[NSMutableArray alloc] init];

    for(int index = 0; order[index] != 0xff; ++ index) {
        NSNumber* type = [NSNumber numberWithInt:order[index]];
        NSString* name = DictionaryNames[order[index]];
        NSDictionary* entity = [NSDictionary dictionaryWithObjectsAndKeys:
                                             type, SKKDictionaryTypeKeys::type,
                                             name, SKKDictionaryTypeKeys::name,
                                             nil];
        [types addObject:entity];
    }

    return [types autorelease];
}

@end

@implementation SKKServer (Local)

- (void)prepareSignalHandler {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    signal(SIGHUP, terminate);
    signal(SIGINT, terminate);
    signal(SIGTERM, terminate);
    signal(SIGPIPE, SIG_IGN);
}

- (void)prepareDirectory {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    NSString* dir = SKKFilePaths::ApplicationSupportFolder;

    if([self fileExistsAtPath:dir] != YES) {
        [self createDirectory:dir];
    }
}

- (void)prepareConnection {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    connection_ = [[NSConnection alloc] init];
#pragma clang diagnostic pop
    [connection_ registerName:SKKSupervisorConnectionName];
    [connection_ setRootObject:self];
    [connection_ runInNewThread];
}

- (void)prepareUserDefaults {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    NSString* factoryDefaults = [self pathForSystemResource:@"UserDefaults.plist"];
    NSString* userDefaults = SKKFilePaths::UserDefaults;

    NSMutableDictionary* defaults = [NSMutableDictionary dictionaryWithContentsOfFile:factoryDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:userDefaults]];
    [defaults writeToFile:userDefaults atomically:YES];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareDictionarySet {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);

    NSString* factoryDictionarySet = [self pathForSystemResource:@"DictionarySet.plist"];
    NSString* userDictionarySet = SKKFilePaths::DictionarySet;

    if([self fileExistsAtPath:userDictionarySet] != YES) {
        os_log_error(serverLog, "%s %@ doesn't exist. Copy from %@", __PRETTY_FUNCTION__, userDictionarySet, factoryDictionarySet);
        NSData* data = [NSData dataWithContentsOfFile:factoryDictionarySet];
        [data writeToFile:userDictionarySet atomically:YES];
    }

    SKKRegisterFactoryMethod<SKKCommonDictionary>(DictionaryTypes::Common);
    SKKRegisterFactoryMethod<SKKCommonDictionaryUTF8>(DictionaryTypes::CommonUTF8);
    SKKRegisterFactoryMethod<SKKAutoUpdateDictionary>(DictionaryTypes::AutoUpdate);
    SKKRegisterFactoryMethod<SKKProxyDictionary>(DictionaryTypes::Proxy);
    SKKRegisterFactoryMethod<MacKotoeriDictionary>(DictionaryTypes::Kotoeri);
    SKKRegisterFactoryMethod<SKKGadgetDictionary>(DictionaryTypes::Gadget);
}

- (void)prepareDictionary {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);

    for(NSDictionary *jisyo in [configuration_ systemDictionaries]) {
        NSString* location = [jisyo valueForKey:SKKDictionarySetKeys::location];
        NSString *path = [self pathForSystemResource:location];

        if (![self fileExistsAtPath:path]) {
            os_log_error(serverLog, "%s: cant' find %@. ignore.", __PRETTY_FUNCTION__, path);
            continue;
        }
        NSString *filename = [path lastPathComponent];
        NSString *userPath = [self pathForUserResource:filename];
        if ([self fileExistsAtPath:userPath]) {
            os_log(serverLog, "%s: %@ already exists. ignore.", __PRETTY_FUNCTION__, userPath);
            continue;
        }
        NSError *error = nil;
        [NSFileManager.defaultManager copyItemAtPath:path toPath:userPath error:&error];
        if (error) {
            os_log_error(serverLog, "%s: can't copy %@ to %@ due to %@", __PRETTY_FUNCTION__, path, userPath, error);
        } else {
            os_log(serverLog, "%s: Wrote %@", __PRETTY_FUNCTION__, userPath);
        }
    }
}

- (void)prepareBlacklistApps {
    os_log(serverLog, "%s", __PRETTY_FUNCTION__);
    NSString* blacklistApps = SKKFilePaths::BlacklistApps;

    if([self fileExistsAtPath:blacklistApps] != YES) {
        NSString* factoryBlacklistApps = [self pathForSystemResource:@"BlacklistApps.plist"];
        NSData* data = [NSData dataWithContentsOfFile:factoryBlacklistApps];
        [data writeToFile:blacklistApps atomically:YES];
    }
}

- (id)newIMKServer {
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    NSString* connection = [info objectForKey:@"InputMethodConnectionName"];
    NSString* identifier = [[NSBundle mainBundle] bundleIdentifier];

    return [[IMKServer alloc] initWithName:connection bundleIdentifier:identifier];
}

- (void)initializeInputModeIcons {
    NSMutableDictionary* icons = [[NSMutableDictionary alloc] initWithCapacity:0];

    for(int i = 0; InputModeIcons[i].name != 0; ++ i) {
        NSImage* image = [NSImage imageNamed:InputModeIcons[i].name];
        [icons setObject:image forKey:[NSNumber numberWithInt:InputModeIcons[i].mode]];
    }

    [[InputModeWindow sharedWindow] setModeIcons:icons];

    [icons release];
}

- (BOOL)fileExistsAtPath:(NSString*)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];

    return [fileManager fileExistsAtPath:path];
}

- (void)createDirectory:(NSString*)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;

    if([fileManager createDirectoryAtPath:path
                    withIntermediateDirectories:YES
                    attributes:nil error:&error] != YES) {
        os_log_error(serverLog, "create directory[%@] failed: %@", path, [error localizedDescription]);
    }
}

- (NSString*)pathForSystemResource:(NSString*)name {
    return [configuration_ systemPathForName:name];
}

- (NSString*)pathForUserResource:(NSString*)name {
    return [configuration_ userPathForName:name];
}

- (NSString*)pathForResource:(NSString*)name {
    return [configuration_ pathForName:name];
}

@end
