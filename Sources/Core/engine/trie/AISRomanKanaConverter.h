//
//  AISRomanKanaConverter.h
//  AquaSKK
//
//  Created by mzp on 8/12/24.
//

#ifndef AISRomanKanaConverter_h
#define AISRomanKanaConverter_h

#import <AquaSKKBackend/SKKInputMode.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AICRomanKanaResult : NSObject
@property(nonatomic, strong) NSString *output;
@property(nonatomic, strong) NSString *intermediate;
@property(nonatomic, strong) NSString *next;
@property(nonatomic, assign) BOOL converted;
@end

@interface AICRomanKanaConverter : NSObject

- (instancetype)initWithPath:(NSString *)path error:(NSError **)error NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)appendPath:(NSString *)path error:(NSError **)error;

- (nullable AICRomanKanaResult *)convert:(NSString *)string inputMode:(SKKInputMode)inputMode;
@end

NS_ASSUME_NONNULL_END

#endif /* AISRomanKanaConverter_h */
