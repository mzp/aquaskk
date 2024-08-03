#include <cassert>
#import <AquaSKKEngine/SKKWindowSelector.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>

#include "MockCandidateWindow.h"

#import <XCTest/XCTest.h>

@interface SKKWindowSelectorTests : XCTestCase
@end

@implementation SKKWindowSelectorTests

- (void)testMain {
    SKKCandidateContainer container;
    MockCandidateWindow test_window;
    SKKWindowSelector selector(&test_window);

    container.push_back(SKKCandidate("候補1"));
    container.push_back(SKKCandidate("候補2"));
    container.push_back(SKKCandidate("候補3"));
    container.push_back(SKKCandidate("候補4"));
    container.push_back(SKKCandidate("候補5"));
    container.push_back(SKKCandidate("候補6"));

    selector.Initialize(container, 3);

    XCTAssert(!selector.IsEmpty() && !selector.Prev() && selector.Current().ToString() == "候補4");

    selector.CursorRight();
    selector.CursorRight();

    XCTAssert(selector.Current().ToString() == "候補6");
}

@end
