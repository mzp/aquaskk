#include <cassert>
#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKEngine/AquaSKKEngine.h>
#import <AquaSKKTesting/AquaSKKTesting.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

@interface SKKInputQueueTests : XCTestCase
@end

@implementation SKKInputQueueTests

- (void)testMain {
    SKKRomanKanaConverterImpl *converter = [SKKRomanKanaConverterImpl sharedInstance];
    NSBundle *bundle = [NSBundle bundleForClass:SKKInputQueueTests.class];
    [converter initialize:[bundle pathForResource:@"kana-rule" ofType:@"conf"]];

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
