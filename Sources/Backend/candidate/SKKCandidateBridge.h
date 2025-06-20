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
- (instancetype)initWithString:(NSString *)string autoParse:(BOOL)autoParse;

@property(nonatomic, readonly) NSString *stringValue;
@property(nonatomic, readonly) NSString *variant;
@property(nonatomic, readonly) const SKKCandidate *rawValue;

- (SKKCandidate)copy;

@end

NS_ASSUME_NONNULL_END
