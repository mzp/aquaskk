#include <cassert>
#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKCore/SKKBackEnd.h>
#import <AquaSKKCore/SKKCommonDictionary.h>
#import <AquaSKKCore/SKKDictionaryFactory.h>

@interface SKKBackEndTests : XCTestCase
@end

@implementation SKKBackEndTests

- (void)testMain {
    SKKRegisterFactoryMethod<SKKCommonDictionary>(0);

    SKKDictionaryKeyContainer dicts;

    NSBundle *bundle = [NSBundle bundleForClass:SKKBackEndTests.class];

    const char *testJisyoPath = [[bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"] UTF8String];

    dicts.push_back(SKKDictionaryKey(0, testJisyoPath));
    dicts.push_back(SKKDictionaryKey(0, testJisyoPath));

    auto &backend = SKKBackEnd::theInstance();

    const char *jisyoPath = [[bundle pathForResource:@"skk-jisyo" ofType:@"utf8"] UTF8String];
    backend.Initialize(jisyoPath, dicts);

    std::vector<std::string> result;
    SKKCandidateSuite suite;

    // 補完
    XCTAssert(backend.Complete("か", result) && result[0] == "かんじ");

    // 検索
    XCTAssert(!backend.Find(SKKEntry("NOT-EXIST", "え"), suite));
    XCTAssert(backend.Find(SKKEntry("よi", "い"), suite) && suite.ToString() == "/良/好/酔/善/");
    XCTAssert(!backend.Find(SKKEntry("NOT-EXIST"), suite));
    XCTAssert(backend.Find(SKKEntry("たんごとうろく"), suite) && suite.ToString() == "/単語登録/");

    // 登録
    backend.Register(SKKEntry("あr", "り"), SKKCandidate("有"));
    backend.Register(SKKEntry("かなめ"), SKKCandidate("要"));

    // 補完
    XCTAssert(backend.Complete("か", result) && result[0] == "かなめ" && result[1] == "かんじ");

    // 検索
    XCTAssert(backend.Find(SKKEntry("あr", "り"), suite) && suite.ToString() == "/有/[り/有/]/");
    XCTAssert(backend.Find(SKKEntry("かなめ"), suite) && suite.ToString() == "/要/");

    // 逆引き
    XCTAssert(backend.ReverseLookup("漢字") == "かんじ");

    // 削除
    backend.Remove(SKKEntry("あr", "り"), SKKCandidate("有"));
    backend.Remove(SKKEntry("かなめ"), SKKCandidate("要"));

    // 補完
    XCTAssert(!backend.Complete("かなめ", result));

    // 検索
    XCTAssert(!backend.Find(SKKEntry("あr", "り"), suite));
    XCTAssert(!backend.Find(SKKEntry("かなめ"), suite));

    // skk-ignore-dic-word 対応
    XCTAssert(backend.Find(SKKEntry("おおk", "き"), suite) && suite.ToString() == "/大/");
    XCTAssert(backend.Find(SKKEntry("むし"), suite) && suite.ToString() == "/蒸し/虫/");
}

@end
