#import <AquaSKKBackend/SKKBaseDictionary.h>
#import <AquaSKKBackend/SKKCommonDictionary.h>
#import <AquaSKKBackend/SKKDictionaryFactory.h>
#include <cassert>

#import <XCTest/XCTest.h>

int main() {
    SKKRegisterFactoryMethod<SKKCommonDictionary>(0);

    auto &factory = SKKDictionaryFactory::theInstance();
    auto *dict = factory.Create(0, "SKK-JISYO.TEST");

    SKKCandidateSuite suite;
    dict->Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/寛治/官寺/");

    return 0;
}
