#include <cassert>
#import <AquaSKKEngine/SKKSelector.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKBackEnd.h>
#import <AquaSKKEngine/SKKCommonDictionary.h>
#import <AquaSKKEngine/SKKDictionaryFactory.h>

#include "MockFrontEnd.h"
#include "MockCandidateWindow.h"
#import <XCTest/XCTest.h>

@interface SKKSelectorTests: XCTestCase
@end

class MockBuddy : public SKKSelectorBuddy {
    SKKCandidate candidate_;

    virtual const SKKEntry SKKSelectorQueryEntry() {
	return SKKEntry("かんじ");
    }

    virtual void SKKSelectorUpdate(const SKKCandidate& candidate) {
	candidate_ = candidate;
    }

public:
    SKKCandidate& Current() { return candidate_; }
};

@implementation SKKSelectorTests

- (void)testMain {
    MockCandidateWindow test_window;
    MockBuddy buddy;
    SKKSelector selector(&buddy, &test_window);
    SKKDictionaryKeyContainer dicts;

    SKKRegisterFactoryMethod<SKKCommonDictionary>(0);

    NSBundle *bundle = [NSBundle bundleForClass:SKKSelectorTests.class];
    const char *path = [bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"].UTF8String;

    dicts.push_back(SKKDictionaryKey(0, path));

    path = [bundle pathForResource:@"skk-jisyo" ofType:@"utf8"].UTF8String;
    SKKBackEnd::theInstance().Initialize(path, dicts);

    XCTAssert(selector.Execute(3) && buddy.Current().ToString() == "漢字");
}

@end
