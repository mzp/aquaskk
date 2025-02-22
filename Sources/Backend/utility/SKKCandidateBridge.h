//
//  SKKCandidateBridge.h
//  AquaSKKInput
//
//  Created by mzp on 2/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

class SKKCandidate;

@interface SKKCandidateBridge : NSObject

+ (instancetype)candidateFromCpp:(const SKKCandidate *)candidate;

@property(nonatomic, readonly) const SKKCandidate *rawValue;

@end

NS_ASSUME_NONNULL_END
