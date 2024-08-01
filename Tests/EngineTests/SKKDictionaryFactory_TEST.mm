#include <cassert>
#include "SKKDictionaryFactory.h"
#include "SKKBaseDictionary.h"
#include "SKKCommonDictionary.h"

#import <XCTest/XCTest.h>


int main() {
    SKKRegisterFactoryMethod<SKKCommonDictionary>(0);

    auto& factory = SKKDictionaryFactory::theInstance();
    auto* dict = factory.Create(0, "SKK-JISYO.TEST");

    SKKCandidateSuite suite;
    dict->Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/寛治/官寺/");

    return 0;
}
