//
//  AISJisyoController.h
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <AquaSKKService/AISJisyo.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(JisyoController)
@interface AISJisyoController : NSObject
@property(nonatomic, readonly, strong) NSString *path;
@property(nonatomic, readonly) NSArray<AISJisyo *> *allJisyo;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

- (void)setJisyo:(AISJisyo *)jisyo enabled:(BOOL)enabled NS_SWIFT_NAME(set(jisyo:enabled:));
- (void)setJisyo:(AISJisyo *)jisyo type:(AISJisyoType)type NS_SWIFT_NAME(set(jisyo:type:));
- (void)setJisyo:(AISJisyo *)jisyo location:(NSString *)location NS_SWIFT_NAME(set(jisyo:location:));

- (void)appendJisyo:(AISJisyo *)jisyo;

@end

NS_ASSUME_NONNULL_END
