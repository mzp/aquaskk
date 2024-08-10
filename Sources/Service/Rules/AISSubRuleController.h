//
//  AISSubRuleController.h
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <Foundation/Foundation.h>
#import <AquaSKKService/AISSubRule.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SubRuleController)
@interface AISSubRuleController : NSObject

@property (nonatomic, readonly) NSArray<AISSubRule *> *allRules;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPath:(NSString *)path activeRules:(NSArray *)activeRules NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
