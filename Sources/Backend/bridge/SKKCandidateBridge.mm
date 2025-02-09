//
//  SKKCandidateBridge.m
//  AquaSKKInput
//
//  Created by mzp on 2/8/25.
//

#import "SKKCandidateBridge.h"
#import <AquaSKKBackend/SKKCandidate.h>

@interface SKKCandidateBridge()

- (instancetype)initWithCandidate:(const SKKCandidate *)candidate;

@end

@implementation SKKCandidateBridge

- (instancetype)initWithCandidate:(const SKKCandidate *)candidate {
    self = [super init];
    if (self) {
        _rawValue = candidate;
    }
    return self;
}

+ (instancetype)candidateFromCpp:(const SKKCandidate *)candidate {
    return [[SKKCandidateBridge alloc] initWithCandidate:candidate];
}

@end
