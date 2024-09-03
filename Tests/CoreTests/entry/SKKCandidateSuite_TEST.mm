#include <cassert>
#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKCore/SKKCandidateSuite.h>

@interface SKKCandidateSuiteTests : XCTestCase
@end

@implementation SKKCandidateSuiteTests

- (void)testAdd {
    SKKCandidateSuite suite;
    SKKCandidateSuite tmp;
    SKKCandidateContainer cand;

    suite.Add(SKKCandidate("候補"));

    cand.push_back(SKKCandidate("ヒント1"));
    cand.push_back(SKKCandidate("ヒント2"));

    suite.Add(SKKOkuriHint("おくり", cand));

    tmp.Add(suite);

    XCTAssert(tmp.ToString() == "/候補/[おくり/ヒント1/ヒント2/]/");
}

- (void)testUpdate {
    SKKCandidateSuite suite;
    SKKCandidateSuite tmp;
    SKKCandidateContainer cand;

    suite.Add(SKKCandidate("候補1"));
    suite.Add(SKKCandidate("候補2"));

    cand.push_back(SKKCandidate("候補1"));
    cand.push_back(SKKCandidate("候補2"));

    suite.Add(SKKOkuriHint("おくり", cand));

    suite.Update(SKKCandidate("候補2;アノテーション"));

    XCTAssert(suite.ToString() == "/候補2;アノテーション/候補1/[おくり/候補1/候補2/]/");

    cand.clear();
    cand.push_back(SKKCandidate("候補1;アノテーション"));

    suite.Update(SKKOkuriHint("おくり", cand));
    XCTAssert(suite.ToString() == "/候補1;アノテーション/候補2;アノテーション/[おくり/候補1;アノテーション/候補2/]/");
}

struct pred : public std::function<bool(SKKCandidate)> {
    bool operator()(const SKKCandidate &candidate) const {
        const std::string &str = candidate.Word();

        return str.find("(skk-ignore-dic-word ") == 0;
    }
};

- (void)testRemove {
    SKKCandidateSuite suite;
    SKKCandidate key("当");

    suite.Parse("/合;(一致) 話が合う/当/[て/当/]/[って/合;(一致) 話が合う/]/");
    suite.Remove(key);
    XCTAssert(suite.ToString() == "/合;(一致) 話が合う/[って/合;(一致) 話が合う/]/");

    suite.Add(SKKCandidate("(skk-ignore-dic-word \"test\")"));
    XCTAssert(suite.ToString() == "/合;(一致) 話が合う/(skk-ignore-dic-word \"test\")/[って/合;(一致) 話が合う/]/");

    suite.RemoveIf(pred());
    XCTAssert(suite.ToString() == "/合;(一致) 話が合う/[って/合;(一致) 話が合う/]/");
}

@end
