#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKBackend/SKKGadgetDictionary.h>

@interface SKKGadgetDictionaryTests : XCTestCase
@end

@implementation SKKGadgetDictionaryTests

- (void)testMain {
    SKKGadgetDictionary dict;

    dict.Initialize("hoge");

    SKKCandidateSuite suite;
    dict.Find(SKKEntry("today"), suite);
    dict.Find(SKKEntry("now"), suite);
    dict.Find(SKKEntry("=(32768+64)*1024"), suite);

    std::cerr << suite.ToString() << std::endl;
}

- (void)testCalc {
    SKKGadgetDictionary dict;
    dict.Initialize("hoge");

    SKKCandidateSuite suite;
    dict.Find(SKKEntry("=(32768+64)*1024"), suite);
    XCTAssertEqualObjects(@"/3.362e+07/", [NSString stringWithUTF8String:suite.ToString().c_str()]);

    suite.Clear();
    dict.Find(SKKEntry("=3*2"), suite);
    XCTAssertEqualObjects(@"/6/", [NSString stringWithUTF8String:suite.ToString().c_str()]);
}

@end
