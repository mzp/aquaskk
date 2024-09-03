#include <cassert>
#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKCore/SKKInputQueue.h>
#include "SKKRomanKanaConverter.h"

@interface SKKInputQueueTests : XCTestCase
@end

class TestInputQueueObserver : public SKKInputQueueObserver {
    State state_;

public:
    virtual void SKKInputQueueUpdate(const State &state) {
        state_.fixed += state.fixed;
        state_.queue = state.queue;
    }

    void Clear() {
        state_ = State();
    }

    bool Test(const std::string &fixed, const std::string &queue) {
        return state_.fixed == fixed && state_.queue == queue;
    }

    void Dump() {
        std::cerr << "fixed=" << state_.fixed << ", queue=" << state_.queue << std::endl;
    }
};

@implementation SKKInputQueueTests

- (void)testMain {
    auto &converter = SKKRomanKanaConverter::theInstance();

    NSBundle *bundle = [NSBundle bundleForClass:SKKInputQueueTests.class];
    const char *path = [bundle pathForResource:@"kana-rule" ofType:@"conf"].UTF8String;

    converter.Initialize(path);

    TestInputQueueObserver observer;
    SKKInputQueue queue(&observer);

    queue.AddChar('a');
    XCTAssert(observer.Test("あ", ""));

    observer.Clear();
    queue.AddChar('k');
    XCTAssert(observer.Test("", "k"));
    queue.AddChar('y');
    XCTAssert(observer.Test("", "ky"));
    queue.RemoveChar();
    XCTAssert(observer.Test("", "k"));
    queue.AddChar('i');
    XCTAssert(observer.Test("き", ""));

    observer.Clear();
    queue.AddChar('n');
    XCTAssert(observer.Test("", "n"));
    queue.Terminate();
    XCTAssert(observer.Test("ん", ""));

    queue.AddChar('n');
    XCTAssert(queue.CanConvert('i'));

    queue.Terminate();
    observer.Clear();
    queue.AddChar('o');
    queue.AddChar('w');
    queue.AddChar('s');
    queue.AddChar('a');
    XCTAssert(observer.Test("おさ", ""));
}

@end
