#include <cassert>
#include "utf8util.h"

#import <XCTest/XCTest.h>

@interface Utf8UtilTests : XCTestCase
@end

@implementation Utf8UtilTests

- (void)testMain {


    std::string str = "ABCいろは日本語ＡＢＣ";

    XCTAssert(utf8::length(str) == 12);
    XCTAssert(utf8::left(str, -6) == "ABCいろは");
    XCTAssert(utf8::right(str, -6) == "日本語ＡＢＣ");
    XCTAssert(utf8::common_prefix("1漢字2", "1漢字3") == "1漢字");
    XCTAssert(utf8::common_prefix("いろは", "あいう") == "");
}

@end
