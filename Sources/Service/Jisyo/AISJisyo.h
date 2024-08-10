//
//  AISJisyo.h
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AISJisyoType) {
    AISJisyoTypeCommon = 0,
    AISJisyoTypeAutoUpdate = 1,
    AISJisyoTypeProxy = 2,
    AISJisyoTypeKotoeri = 3,
    AISJisyoTypeGadget = 4,
    AISJisyoTypeCommonUTF8 = 5,
} NS_SWIFT_NAME(JisyoType);

/// SKK辞書
NS_SWIFT_NAME(Jisyo)
@interface AISJisyo : NSObject

/// 有効無効
@property(assign, nonatomic) BOOL enabled;
@property(assign, nonatomic) AISJisyoType type;
@property(strong, nonatomic) NSString *location;

@property(readonly, nonatomic) NSString *displayType;
@property(readonly, nonatomic) NSString *displayLocation;

@property(readonly, nonatomic) NSDictionary *dictionary;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dictionary NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithType:(AISJisyoType)type location:(NSString *)location enabled:(BOOL)enabled;

+ (NSString *)displayNameForJisyoType:(AISJisyoType)jisyoType;
@end

NS_ASSUME_NONNULL_END
