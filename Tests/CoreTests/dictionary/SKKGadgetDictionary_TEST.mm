#import <AquaSKKCore/SKKGadgetDictionary.h>
#import <XCTest/XCTest.h>
#include <iostream>

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
