//
//  SKKEntryBridge.h
//  AquaSKKBackend
//
//  Created by mzp on 2025/06/17.
//

#import <Foundation/Foundation.h>
#import <AquaSKKBackend/SKKInputMode.h>

NS_ASSUME_NONNULL_BEGIN

class SKKEntry;

@interface SKKEntryBridge : NSObject

@property(nonatomic, readonly) SKKEntry *rawValue;

@property(nonatomic, readonly) NSString *entryString;
@property(nonatomic, readonly) NSString *promptString;
@property(nonatomic, readonly) NSString *okuriString;

@property(nonatomic, readonly) BOOL isEmpty;
@property(nonatomic, readonly) BOOL isOkuriAri;

- (instancetype)initWithEntry:(NSString *)entry okuri:(NSString *)okuri;

- (void)setOkuri:(NSString *)prefix kana:(NSString *)kana;
- (void)appendEntry:(NSString *)string;
- (NSString *)toggleKana:(SKKInputMode)inputMode;
- (NSString *)toggleJisx0201Kana:(SKKInputMode)inputMode;
- (SKKEntryBridge *)normalize:(SKKInputMode)inputMode;
- (SKKEntry)copy;

@end

NS_ASSUME_NONNULL_END
