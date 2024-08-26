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

/// SKKサーバー動作に必要なリソースを管理する。
NS_SWIFT_NAME(ServerConfiguration)
@protocol AISServerConfiguration

// MARK: - Jisyo(SKK Dictionary)

@property(nonatomic, readonly) NSString *userDictionaryPath;

/// 辞書情報を保存するplistへのパス。要書き込み権限。
@property(nonatomic, readonly) NSString *dictionarySetPath;

// TODO: AISJisyoを使う
- (NSArray<NSDictionary *> *)systemDictionaries;

// MARK: - User Defaults

@property(nonatomic, readonly) NSString *userDefaultsPath;
@property(nonatomic, readonly) NSString *factoryUserDefaultsPath;

// MARK: - Other(to be removed)

@property(nonatomic, readonly) NSString *systemResourcePath;
@property(nonatomic, readonly) NSString *applicationSupportPath;

/// Path for managed resource.
- (NSString *)pathForName:(NSString *)name;

/// Path for system bundled resoruce
- (NSString *)systemPathForName:(NSString *)name;

//// Path for user customized file. may not be exist
- (NSString *)userPathForName:(NSString *)name;

@end
NS_ASSUME_NONNULL_END

#endif /* AISServerConfiguration_h */
