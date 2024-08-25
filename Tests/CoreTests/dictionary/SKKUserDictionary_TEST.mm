#include "MockCompletionHelper.h"
#import <AquaSKKCore/SKKLocalUserDictionary.h>
#include <cassert>
#include <iostream>

#import <XCTest/XCTest.h>

@interface SKKUserDictionaryTests : XCTestCase
@end

@implementation SKKUserDictionaryTests

- (void)testMain {
    SKKLocalUserDictionary dict;
    SKKCandidateSuite suite;

    NSBundle *bundle = [NSBundle bundleForClass:SKKUserDictionaryTests.class];
    NSString *path = [bundle pathForResource:@"skk-jisyo" ofType:@"utf8"];

    dict.Initialize([path UTF8String]);

    dict.Find(SKKEntry("#"), suite);
    XCTAssert(suite.IsEmpty());

    dict.Find(SKKEntry("おくりあr", "り"), suite);
    XCTAssert(suite.ToString() == "/送り有/");

    suite.Clear();
    dict.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/");

    dict.Register(SKKEntry("おくりあr", "り"), SKKCandidate("送りあ"));
    dict.Register(SKKEntry("かんり"), SKKCandidate("管理"));

    suite.Clear();

    dict.Find(SKKEntry("おくりあr", "り"), suite);
    XCTAssert(suite.ToString() == "/送りあ/[り/送りあ/]/");

    suite.Clear();
    dict.Find(SKKEntry("かんり"), suite);
    XCTAssert(suite.ToString() == "/管理/");

    MockCompletionHelper helper;
    helper.Initialize("かん");
    dict.Complete(helper);
    XCTAssert(helper.Result()[0] == "かんり" && helper.Result()[1] == "かんじ");

    dict.Remove(SKKEntry("おくりあr", "り"), SKKCandidate("送りあ"));
    dict.Remove(SKKEntry("かんり"), SKKCandidate("管理"));

    suite.Clear();
    dict.Find(SKKEntry("おくりあr", "り"), suite);
    XCTAssert(suite.ToString() == "/送り有/");

    suite.Clear();
    dict.Find(SKKEntry("かんり"), suite);
    XCTAssert(suite.IsEmpty());

    dict.SetPrivateMode(true);

    suite.Clear();
    dict.Find(SKKEntry("おくりあr", "り"), suite);
    XCTAssert(suite.ToString() == "/送り有/");

    suite.Clear();
    dict.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/");

    dict.Register(SKKEntry("おくりあr", "り"), SKKCandidate("送りあ"));
    dict.Register(SKKEntry("かんり"), SKKCandidate("管理"));

    suite.Clear();
    dict.Find(SKKEntry("おくりあr", "り"), suite);
    XCTAssert(suite.ToString() == "/送りあ/[り/送りあ/]/");

    suite.Clear();
    dict.Find(SKKEntry("かんり"), suite);
    XCTAssert(suite.ToString() == "/管理/");

    dict.SetPrivateMode(false);

    suite.Clear();
    dict.Find(SKKEntry("おくりあr", "り"), suite);
    XCTAssert(suite.ToString() == "/送り有/");

    suite.Clear();
    dict.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/");

    XCTAssert(dict.ReverseLookup("漢字") == "かんじ");

    dict.Remove(SKKEntry("ほかん1"), SKKCandidate(""));
    suite.Clear();
    dict.Find(SKKEntry("ほかん1"), suite);
    XCTAssert(suite.ToString() == "/補完1/");

    dict.Register(SKKEntry("とぐるほかん"), SKKCandidate(""));
    suite.Clear();
    dict.Find(SKKEntry("とぐるほかん"), suite);
    XCTAssert(suite.IsEmpty());

    dict.Remove(SKKEntry("とぐるほかん"), SKKCandidate(""));
    suite.Clear();
    dict.Find(SKKEntry("とぐるほかん"), suite);
    XCTAssert(suite.IsEmpty());

    helper.Initialize("かんり");
    dict.Complete(helper);
    XCTAssert(helper.Result().empty());

    suite.Clear();
    dict.Register(SKKEntry("encode"), SKKCandidate("abc;def"));
    dict.Find(SKKEntry("encode"), suite);
    XCTAssert(suite.ToString() == "/abc;def/");

    suite.Clear();
    dict.Remove(SKKEntry("encode"), SKKCandidate("abc;def"));
    dict.Find(SKKEntry("encode"), suite);
    XCTAssert(suite.IsEmpty());

    dict.Register(SKKEntry("#"), SKKCandidate("456"));
}

@end
