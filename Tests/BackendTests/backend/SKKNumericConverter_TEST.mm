#include <cassert>
#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKBackend/SKKNumericConverter.h>

@interface SKKNumericConverterTests : XCTestCase
@end

@implementation SKKNumericConverterTests

- (void)testMain {
    SKKNumericConverter converter;

    // 数値変換の対象外
    XCTAssert(!converter.Setup("abc"));
    XCTAssert(converter.OriginalKey() == "abc");
    XCTAssert(converter.NormalizedKey() == "abc");

    // 数値変換対象
    XCTAssert(converter.Setup("0-1-2-1234-4-1234-34"));
    XCTAssert(converter.NormalizedKey() == "#-#-#-#-#-#-#");

    SKKCandidate candidate("#0-#1-#2-#3-#4-#5-#9");
    converter.Apply(candidate);

    // std::cerr << candidate.Variant() << std::endl;
    XCTAssert(candidate.Variant() == "0-１-二-千二百三十四-4-壱阡弐百参拾四-３四");
}

@end
