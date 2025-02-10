//
//  SKKBackEndBridge.h
//  AquaSKKBackend
//
//  Created by mzp on 2/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SKKBackEndBridge : NSObject

+ (instancetype)sharedInstance;

// 初期化
- (void)initializeWithUserDictionaryPath:(NSString *)path systemDictionaries:(NSArray *)keys;

// オプション：数値変換
- (void)setNumericConversionEnabled:(BOOL)enabled;

// オプション：拡張補完
- (void)setExtendedCompletionEnabled:(BOOL)enabled;

// オプション：プライベートモード
- (void)setPrivateModeEnabled:(BOOL)enabled;

// オプション：補完候補の長さの下限(足切り)
- (void)setMinimumCompletionLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
