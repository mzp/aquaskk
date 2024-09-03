//
//  AISJisyoConttroller.m
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <Foundation/Foundation.h>
#import <os/log.h>
#import <AquaSKKService/AISJisyo.h>
#import <AquaSKKService/AISJisyoController.h>
#import <AquaSKKService/SKKConstVars.h>

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

    NSString *DictionaryNames[] = {@"SKK 辞書(EUC-JP)", @"SKK 辞書(自動ダウンロード)",
                                   @"skkserv 辞書",     @"ことえり辞書",
                                   @"プログラム辞書",   @"SKK 辞書(UTF-8)"};
} // namespace

@interface AISJisyoController ()

@property(nonatomic, strong) NSMutableArray<NSMutableDictionary *> *dictionarySet;

@end

@implementation AISJisyoController

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if(self) {
        _path = path;
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        self.dictionarySet = [[NSMutableArray arrayWithContentsOfURL:url error:&error] mutableCopy];
        if(error != nil) {
            os_log_error(OS_LOG_DEFAULT, "can't load %@ set due to %@", url, error);
        }
        NSAssert(self.dictionarySet, @"can't find dictionary set plist");
    }
    return self;
}

- (NSArray<AISJisyo *> *)allJisyo {
    NSMutableArray *allJisyo = [NSMutableArray arrayWithCapacity:self.dictionarySet.count];
    for(NSMutableDictionary *entry in self.dictionarySet) {
        AISJisyo *jisyo = [[AISJisyo alloc] initWithDictionary:entry];
        [allJisyo addObject:jisyo];
    }
    return allJisyo;
}

- (void)setJisyo:(AISJisyo *)jisyo enabled:(BOOL)enabled {
    jisyo.enabled = enabled;
    [self flush];
}

- (void)setJisyo:(AISJisyo *)jisyo type:(AISJisyoType)type {
    jisyo.type = type;
    [self flush];
}

- (void)setJisyo:(AISJisyo *)jisyo location:(NSString *)location {
    jisyo.location = location;
    [self flush];
}

- (void)flush {
    [self.dictionarySet writeToFile:self.path atomically:YES];
}

- (void)appendJisyo:(AISJisyo *)jisyo {
    [self.dictionarySet addObject:[jisyo.dictionary mutableCopy]];
}

@end
