#include <cassert>
#include "SKKDictionaryKeeper.h"
#include "MockCompletionHelper.h"

#import <XCTest/XCTest.h>

@interface SKKDictionaryKeeperTests: XCTestCase
@end

class DebugLoader : public SKKDictionaryLoader {
    std::string path_;

    virtual bool NeedsUpdate() {
        return true;
    }

    virtual const std::string& FilePath() const {
        return path_;
    }

public:
    virtual void Initialize(const std::string& path) {
        path_ = path;
    }

    virtual int Interval() const { return 5; }

    virtual int Timeout() const { return 5; }
};

@implementation SKKDictionaryKeeperTests

- (void)testMain {
    XCTSkip(@"FIXME: SKKDictionaryKeeper causes crash after test passed");
    DebugLoader loader;
    SKKDictionaryKeeper keeper;
    MockCompletionHelper helper;

    NSBundle *bundle = [NSBundle bundleForClass:SKKDictionaryKeeperTests.class];

    loader
        .Initialize([bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"].UTF8String);

    keeper.Initialize(&loader);

    XCTAssert(keeper.ReverseLookup("官寺") == "かんじ");

    helper.Initialize("か");
    keeper.Complete(helper);

    XCTAssert(helper.Result()[0] == "かんじ");
}

@end
