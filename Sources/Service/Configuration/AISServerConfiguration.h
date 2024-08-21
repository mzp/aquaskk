//
//  AISServerConfiguration.h
//  AquaSKK
//
//  Created by mzp on 8/14/24.
//

#ifndef AISServerConfiguration_h
#define AISServerConfiguration_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// TODO: SKKServerのうちパスに依存する部分を切り出したもの。FileConfigurationと統合したい。
/// SKKサーバー動作に必要なリソースを管理する。
NS_SWIFT_NAME(ServerConfiguration)
@protocol AISServerConfiguration

/// Path for managed resource.
- (NSString *)pathForName:(NSString *)name;

/// Path for system bundled resoruce
- (NSString *)systemPathForName:(NSString *)name;

//// Path for user customized file. may not be exist
- (NSString *)userPathForName:(NSString *)name;

- (nullable NSString *)userDictionaryPath;

// TODO: AISJisyoを使う
- (NSArray<NSDictionary *> *)systemDictionaries;

// MARK: - User Defaults

@property(nonatomic, readonly) NSString *userDefaultsPath;
@property(nonatomic, readonly) NSString *factoryUserDefaultsPath;

@end
NS_ASSUME_NONNULL_END

#endif /* AISServerConfiguration_h */
