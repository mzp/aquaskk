//
//  AISDefaultServerConfiguration.m
//  AquaSKKService
//
//  Created by mzp on 8/14/24.
//

#import "AISDefaultServerConfiguration.h"
#import <AquaSKKService/SKKConstVars.h>
#import <os/log.h>

// FIXME: /Library/Input Methods/AquaSKK.appとしてインストールしないと動作しない
@implementation AISDefaultServerConfiguration

- (NSString*)systemPathForName:(NSString*)name {
    return [NSString stringWithFormat:@"%@/%@", SKKFilePaths::SystemResourceFolder, name];
}

- (NSString*)userPathForName:(NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", SKKFilePaths::ApplicationSupportFolder, name];
}

- (NSString*)pathForName:(NSString*)name {
    NSString* tmp = [self userPathForName:name];

    if([self fileExistsAtPath:tmp] == YES) {
        return tmp;
    } else {
        return [self systemPathForName:name];
    }
}

- (BOOL)fileExistsAtPath:(NSString*)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];

    return [fileManager fileExistsAtPath:path];
}

- (NSString *)userDictionaryPath
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userDictionary = [defaults stringForKey:SKKUserDefaultKeys::user_dictionary_path];
    return [userDictionary stringByExpandingTildeInPath];
}

- (NSArray<NSDictionary *> *)systemDictionaries {
    NSString *path = SKKFilePaths::DictionarySet;
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    if(array == nil) {
        os_log_error(OS_LOG_DEFAULT, "can't read %@", path);
    }
    return array ?: @[];
}

- (NSString *)factoryUserDefaultsPath {
    return [self systemPathForName:@"UserDefaults.plist"];
}

- (NSString *)userDefaultsPath {
    return SKKFilePaths::UserDefaults;
}

@end
