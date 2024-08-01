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

    XCTAssert(!selector.IsEmpty() && !selector.Prev() && selector.Current().ToString() == "候補1");
    XCTAssert(selector.Next() && selector.Current().ToString() == "候補2");
    XCTAssert(selector.Next() && !selector.Next() && selector.Current().ToString() == "候補3");
    XCTAssert(selector.Prev() && selector.Current().ToString() == "候補2");
}

@end
