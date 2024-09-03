#include <iostream>
#import <XCTest/XCTest.h>
#import <AquaSKKCore/SKKGadgetDictionary.h>

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

@end
