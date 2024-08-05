//
//  SKSResourceConfiguration.h
//  AquaSKK
//
//  Created by mzp on 8/6/24.
//

#ifndef SKSResourceConfiguration_h
#define SKSResourceConfiguration_h

NS_ASSUME_NONNULL_BEGIN

@protocol SKSResourceConfiguration

- (NSString *)pathForSystemResource:(NSString *)path;
- (NSString *)pathForUserResource:(NSString *)path;
- (NSString *)pathForResource:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

#endif /* SKSResourceConfiguration_h */
