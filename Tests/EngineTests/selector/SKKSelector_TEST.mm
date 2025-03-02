#include <cassert>
#import <XCTest/XCTest.h>
#import <AquaSKKBackend/SKKBackEnd.h>
#import <AquaSKKBackend/SKKCommonDictionary.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKSelector.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockFrontEnd.h>
#import <AquaSKKTesting/MockSelectorBuddy.h>

@interface SKKSelectorTests : XCTestCase
@end

@implementation SKKSelectorTests

- (void)testMain {
    MockCandidateWindow test_window;
    MockSelectorBuddy buddy;
    SKKSelector selector(&buddy, &test_window);
    SKKDictionaryKeyContainer dicts;

    NSBundle *bundle = [NSBundle bundleForClass:SKKSelectorTests.class];
    const char *path = [bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"].UTF8String;

    dicts.push_back(SKKDictionaryKey(0, path));

    path = [bundle pathForResource:@"skk-jisyo" ofType:@"utf8"].UTF8String;
    SKKBackEnd::theInstance().Initialize(path, dicts);

    XCTAssert(selector.Execute(3) && buddy.Current().ToString() == "漢字");
}

@end
