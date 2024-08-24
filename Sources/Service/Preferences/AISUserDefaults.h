//
//  AISUserDefaults.h
//  AquaSKKService
//
//  Created by mzp on 8/24/24.
//

#import <AquaSKKService/AISServerConfiguration.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AISUserDefaults : NSObject
- (instancetype)initWithServerConfiguration:(id<AISServerConfiguration>)serverConfiguration NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)prepareUserDefaults;

- (void)saveChanges;

@property(nonatomic, readonly) NSUserDefaults *standardDefaults NS_SWIFT_NAME(standard);

@end

NS_ASSUME_NONNULL_END
