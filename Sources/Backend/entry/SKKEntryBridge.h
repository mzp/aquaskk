//
//  SKKEntryBridge.h
//  AquaSKKBackend
//
//  Created by mzp on 2025/06/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

class SKKEntry;

@interface SKKEntryBridge : NSObject
@property(nonatomic, readonly) const SKKEntry *rawValue;
@end

NS_ASSUME_NONNULL_END
