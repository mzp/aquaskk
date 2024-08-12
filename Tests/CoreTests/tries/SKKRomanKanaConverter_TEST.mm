#include "SKKRomanKanaConverter.h"
#import <XCTest/XCTest.h>
#include <cassert>
#include <iostream>

@interface SKKRomanKanaConverterTests : XCTestCase
@end

void dump(const std::string &input, const SKKRomanKanaConversionResult &result) {
    std::cerr << "input=" << input << ",next=" << result.next << ",output=" << result.output
              << ",intermediate=" << result.intermediate << std::endl;
}

@implementation SKKRomanKanaConverterTests

- (void)testMain {
    auto &conv = SKKRomanKanaConverter::theInstance();

    NSBundle *bundle = [NSBundle bundleForClass:SKKRomanKanaConverterTests.class];
    const char *path = [bundle pathForResource:@"kana-rule" ofType:@"conf"].UTF8String;
    conv.Initialize(path);

    bool result;

    SKKRomanKanaConversionResult state;

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "a", state);
    XCTAssert(result && state.next == "" && state.output == "あ");

    result = conv.Convert(SKKInputMode::KatakanaInputMode, "a", state);
    XCTAssert(state.next == "" && state.output == "ア");

    result = conv.Convert(SKKInputMode::Jisx0201KanaInputMode, "a", state);
    XCTAssert(state.next == "" && state.output == "ｱ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "gg", state);
    XCTAssert(state.next == "g" && state.output == "っ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, ",", state);
    XCTAssert(state.next == "" && state.output == "、");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "#", state);
    XCTAssert(state.next == "" && state.output == "＃");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, " ", state);
    XCTAssert(state.next == "" && state.output == " ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "kyl", state);
    XCTAssert(state.next == "" && state.output == "l");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "z,", state);
    XCTAssert(state.next == "" && state.output == "‥");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "co", state);
    XCTAssert(state.next == "" && state.output == "お");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "'", state);
    XCTAssert(state.next == "" && state.output == "'");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "k1", state);
    XCTAssert(state.next == "" && state.output == "1");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "kgya", state);
    XCTAssert(state.next == "" && state.output == "ぎゃ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "k1234gya", state);
    XCTAssert(state.next == "" && state.output == "1234ぎゃ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "gyagyugyo", state);
    XCTAssert(state.next == "" && state.output == "ぎゃぎゅぎょ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "chho", state);
    XCTAssert(state.next == "" && state.output == "ほ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "c", state);
    XCTAssert(state.next == "c" && state.output == "");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "pmp", state);
    XCTAssert(state.next == "p" && state.output == "");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "pmpo", state);
    XCTAssert(state.next == "" && state.output == "ぽ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "kanji", state);
    XCTAssert(state.next == "" && state.output == "かんじ");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "/", state);
    XCTAssert(state.next == "" && state.output == "/");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "z ", state);
    XCTAssert(state.next == "" && state.output == "　");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, "z\\", state);
    XCTAssert(state.next == "" && state.output == "￥");

    result = conv.Convert(SKKInputMode::HirakanaInputMode, ".", state);
    XCTAssert(state.output == "。");

    path = [bundle pathForResource:@"period" ofType:@"rule"].UTF8String;
    conv.Patch(path);

    result = conv.Convert(SKKInputMode::HirakanaInputMode, ".", state);
    XCTAssert(state.output == "．");
}

@end
