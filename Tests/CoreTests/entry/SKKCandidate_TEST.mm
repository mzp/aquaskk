#include <cassert>
#import <AquaSKKCore/SKKCandidate.h>

#import <XCTest/XCTest.h>

@interface SKKCandidateTests : XCTestCase
@end

@implementation SKKCandidateTests

- (void)testMain {
    SKKCandidate c1;

    XCTAssert(c1.IsEmpty() && c1.ToString() == "");

    std::string src("候補;アノテーション");
    SKKCandidate c2(src);

    XCTAssert(c2.Word() == "候補" && c2.Annotation() == "アノテーション");
    XCTAssert(c2.ToString() == src);

    c1 = c2;

    XCTAssert(c1.ToString() == src && c1 == c2);

    std::string variant("数値変換");
    c1.SetVariant(variant);

    XCTAssert(c1.Variant() == variant && c1 != c2);

    XCTAssert(SKKCandidate::Encode("[/;") == "[5b][2f][3b]");
    XCTAssert(SKKCandidate::Decode("[5b][2f][3b]") == "[/;");
}

@end
