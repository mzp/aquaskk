//
//  SKKBackEndBridge.m
//  AquaSKKBackend
//
//  Created by mzp on 2/10/25.
//

#import "SKKBackEndBridge.h"
#import <AquaSKKBackend/SKKBackEnd.h>
#import <AquaSKKService/SKKConstVars.h>

@implementation SKKBackEndBridge

+ (instancetype)sharedInstance {
    static SKKBackEndBridge *instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[SKKBackEndBridge alloc] init];
    });
    return instance;
}

- (void)initializeWithUserDictionaryPath:(NSString *)path systemDictionaries:(NSArray *)keys {
    SKKDictionaryKeyContainer container;

    for(NSArray *entry in keys) {
        NSNumber *type = entry[0];
        NSString *location = entry[1];
        container.push_back(SKKDictionaryKey([type intValue], [location UTF8String]));
    }
    SKKBackEnd::theInstance().Initialize([path UTF8String], container);
}

- (void)setNumericConversionEnabled:(BOOL)enabled {
    SKKBackEnd::theInstance().UseNumericConversion(enabled);
}
// オプション：拡張補完
- (void)setExtendedCompletionEnabled:(BOOL)enabled {
    SKKBackEnd::theInstance().EnableExtendedCompletion(enabled);
}

// オプション：プライベートモード
- (void)setPrivateModeEnabled:(BOOL)enabled {
    SKKBackEnd::theInstance().EnablePrivateMode(enabled);
}

// オプション：補完候補の長さの下限(足切り)
- (void)setMinimumCompletionLength:(NSInteger)length {
    SKKBackEnd::theInstance().SetMinimumCompletionLength(static_cast<int>(length));
}

@end
