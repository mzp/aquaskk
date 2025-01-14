#include <cassert>
#import <XCTest/XCTest.h>
#include <sys/stat.h>
#import <AquaSKKBackend/SKKAutoUpdateDictionary.h>

@interface SKKAutoUpdateDictionaryTests : XCTestCase
@end

@implementation SKKAutoUpdateDictionaryTests

- (void)testMain {
    const char *path1 = "SKK-JISYO.S1";
    const char *path2 = "SKK-JISYO.S2";
    SKKAutoUpdateDictionary dict1, dict2;
    SKKCandidateSuite suite;

    remove(path1);
    remove(path2);

    dict1.Initialize("openlab.ring.gr.jp /skk/skk/dic/SKK-JISYO.S SKK-JISYO.S1");
    dict2.Initialize("openlab.ring.gr.jp:80 /skk/skk/dic/SKK-JISYO.S SKK-JISYO.S2");

    dict1.Find(SKKEntry("dummy", "d"), suite);
    dict2.Find(SKKEntry("dummy", "d"), suite);

    struct stat st1, st2;

    stat(path1, &st1);
    stat(path2, &st2);

    XCTAssert(st1.st_size == st2.st_size);

    XCTAssert(dict1.ReverseLookup("逆") == "ぎゃく");
    XCTAssert(dict2.ReverseLookup("逆") == "ぎゃく");
}

@end
