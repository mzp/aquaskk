//
//  AISUserDefaults.h
//  AquaSKKService
//
//  Created by mzp on 8/24/24.
//

#import <Foundation/Foundation.h>
#import <AquaSKKService/AISServerConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface AISUserDefaults : NSObject
- (instancetype)initWithServerConfiguration:(id<AISServerConfiguration>)serverConfiguration NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)prepareUserDefaults;

- (void)reloadUserDefaults;

- (void)saveChanges;

@property(nonatomic, readonly) NSUserDefaults *standardDefaults NS_SWIFT_NAME(standard);

@end

NS_ASSUME_NONNULL_END
