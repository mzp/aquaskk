#import <AquaSKKIM/SKKServer.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKKServer (Private)

/// Start SKKServer without IMK connection. Testing only.
- (void)_start;

/// Path for managed resource.
- (NSString *)pathForResource:(NSString *)path;

- (void)loadDictionarySetFromPath:(nullable NSString *)userDictionary
               systemDictionaries:(NSArray<NSDictionary *> *)array;
@end

NS_ASSUME_NONNULL_END
