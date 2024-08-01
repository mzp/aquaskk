#include <cassert>
#include "SKKInlineSelector.h"
#import <XCTest/XCTest.h>

@interface SKKInlineSelectorTests: XCTestCase
@end

@implementation SKKInlineSelectorTests

- (void)testMain {
    SKKCandidateContainer container;
    SKKInlineSelector selector;
    
    container.push_back(SKKCandidate("候補1"));
    container.push_back(SKKCandidate("候補2"));
    container.push_back(SKKCandidate("候補3"));

    selector.Initialize(container, 3);

    assert(!selector.IsEmpty() && !selector.Prev() && selector.Current().ToString() == "候補1");
    assert(selector.Next() && selector.Current().ToString() == "候補2");
    assert(selector.Next() && !selector.Next() && selector.Current().ToString() == "候補3");
    assert(selector.Prev() && selector.Current().ToString() == "候補2");
}

@end
