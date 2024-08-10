//
//  AISSubRule.h
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SubRule)
@interface AISSubRule : NSObject

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *ruleDescription;
@property(nonatomic, strong, nullable) NSString *keymap;

@end

NS_ASSUME_NONNULL_END
