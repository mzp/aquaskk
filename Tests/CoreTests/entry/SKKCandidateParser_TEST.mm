#include <cassert>
#import <AquaSKKCore/SKKCandidateParser.h>

#import <XCTest/XCTest.h>

@interface SKKCandidateParserTests : XCTestCase

@end

@implementation SKKCandidateParserTests

- (void)testMain {
    SKKCandidateParser parser;

    parser.Parse("//");
    XCTAssert(parser.Candidates().empty() && parser.Hints().empty());

    parser.Parse("/候補1/");
    XCTAssert(parser.Candidates().size() == 1 && parser.Candidates()[0] == SKKCandidate("候補1"));

    parser.Parse("/候補1/候補2;アノテーション/候補3/");
    XCTAssert(parser.Candidates().size() == 3 && parser.Candidates()[1] == SKKCandidate("候補2"));

    parser.Parse("/候補1/[おくり/候補1/]/");
    SKKOkuriHint hint;
    hint.first = "おくり";
    hint.second.push_back(std::string("候補1"));
    XCTAssert(parser.Candidates().size() == 1 && parser.Hints().size() == 1 && parser.Hints()[0] == hint);

    parser.Parse("/候補;[]][アノテーション/");
    XCTAssert(parser.Candidates().size() == 1 && parser.Hints().empty());

    parser.Parse("//[]/[///]/[おくり/候補1/候補2/]//");
    XCTAssert(parser.Candidates().empty() && parser.Hints().size() == 1
	   && parser.Hints()[0].second[1] == SKKCandidate("候補2"));
}

@end
