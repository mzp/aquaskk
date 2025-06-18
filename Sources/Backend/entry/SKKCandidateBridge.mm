//
//  SKKCandidateBridge.m
//  AquaSKKInput
//
//  Created by mzp on 2/8/25.
//

#import "SKKCandidateBridge.h"
#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKBackend/SKKEncoding.h>

@interface SKKCandidateBridge ()

- (instancetype)initWithCandidate:(const SKKCandidate *)candidate;

@end

@implementation SKKCandidateBridge

- (instancetype)initWithCandidate:(const SKKCandidate *)candidate {
    self = [super init];
    if(self) {
        _rawValue = candidate;
    }
    return self;
}

+ (instancetype)candidateFromCpp:(const SKKCandidate *)candidate {
    return [[SKKCandidateBridge alloc] initWithCandidate:candidate];
}

- (instancetype)initWithString:(NSString *)string autoParse:(BOOL)autoParse
{
    if (self = [super init]) {
        _rawValue = new SKKCandidate(string.UTF8String, autoParse);
    }
    return self;
}

- (void)dealloc
{
    delete _rawValue;
}

- (NSString *)stringValue
{
    return SKKUTF8String(_rawValue->ToString());
}

- (NSString *)variant
{
    return SKKUTF8String(_rawValue->Variant());
}

- (SKKCandidate)copy
{
    return *_rawValue;
}

@end
