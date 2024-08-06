//
//  AISResourceConfiguration.h
//  AquaSKK
//
//  Created by mzp on 8/6/24.
//

#ifndef AISResourceConfiguration_h
#define AISResourceConfiguration_h

NS_ASSUME_NONNULL_BEGIN

@protocol AISResourceConfiguration

- (NSString *)pathForSystemResource:(NSString *)path;
- (NSString *)pathForUserResource:(NSString *)path;
- (NSString *)pathForResource:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

#endif /* AISResourceConfiguration_h */
