#include <cassert>
#import <XCTest/XCTest.h>
#import <AquaSKKCore/SKKCommonDictionary.h>

void test(SKKBaseDictionary &dict) {
    SKKCandidateSuite suite;

    dict.Find(SKKEntry("NOT_EXIST", "d"), suite);
    XCTAssert(suite.IsEmpty());

    dict.Find(SKKEntry("よi", "い"), suite);
    XCTAssert(suite.ToString() == "/良/好/酔/善/");

    suite.Clear();
    dict.Find(SKKEntry("NOT_EXIST"), suite);
    XCTAssert(suite.IsEmpty());

    dict.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/寛治/官寺/");

    XCTAssert(dict.ReverseLookup("漢字") == "かんじ");
}

@interface SKKCommonDictionaryTests : XCTestCase
@end

@implementation SKKCommonDictionaryTests

- (void)testMain {
    XCTSkip(@"FIXME: SKKDictionaryKeeper causes crash after test passed");
    NSBundle *bundle = [NSBundle bundleForClass:SKKCommonDictionaryTests.class];

    SKKCommonDictionary dict;

    dict.Initialize([bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"].UTF8String);

    test(dict);

    SKKCommonDictionaryUTF8 utf8;

    utf8.Initialize([bundle pathForResource:@"SKK-JISYO.TEST" ofType:@"UTF8"].UTF8String);

    test(utf8);
}

@end
