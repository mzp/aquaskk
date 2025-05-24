#include <cassert>
#import <XCTest/XCTest.h>
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKEngine/SKKCompleter.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

class TestBuddy : public SKKCompleterBuddy {
    std::string query_;

    virtual const std::string SKKCompleterQueryString() {
        return query_;
    }

    virtual void SKKCompleterUpdate(const std::string &entry) {
        query_ = entry;
    }

public:
    void SetQuery(const std::string &str) {
        query_ = str;
    }

    const std::string &Entry() const {
        return query_;
    }
};

@interface SKKCompleterTests : XCTestCase

@end

@implementation SKKCompleterTests

- (void)testMain {
    TestBuddy buddy;
    SKKCompleter completer(&buddy);
    SKKDictionaryKeyContainer dicts;

    auto backend = AquaSKKBackend::SKKBackendImpl::shared();

    NSBundle *bundle = [NSBundle bundleForClass:SKKCompleterTests.class];
    backend.bridgeInitialize([bundle pathForResource:@"skk-jisyo" ofType:@"utf8"].UTF8String, dicts);
    buddy.SetQuery("ほかん");

    XCTAssert(completer.Execute());
    XCTAssert(buddy.Entry() == "ほかん1");

    completer.Next();
    completer.Next();

    XCTAssert(buddy.Entry() == "ほかん3");

    backend.register_(SKKEntry("とぐるほかん"), SKKCandidate());

    buddy.SetQuery("とぐる");
    XCTAssert(completer.Execute() && buddy.Entry() == "とぐるほかん");

    backend.remove(SKKEntry("とぐるほかん"), SKKCandidate());
    XCTAssert(!completer.Execute());
}

@end
