#include "stringutil.h"
#include <cassert>
#include <iostream>
#include <vector>

#import <XCTest/XCTest.h>

@interface StringUtilTests : XCTestCase
@end

@implementation StringUtilTests

- (void)testMain {
    string::splitter splitter;
    std::string str;

    splitter.split("a,b,c,d");

    XCTAssert(splitter >> str && str == "a");
    XCTAssert(splitter >> str && str == "b");
    XCTAssert(splitter >> str && str == "c");
    XCTAssert(splitter >> str && str == "d");
    XCTAssert(!(splitter >> str));

    splitter.split("abc::def::ghi", "::");

    XCTAssert(splitter >> str && str == "abc");
    XCTAssert(splitter >> str && str == "def");
    XCTAssert(splitter >> str && str == "ghi");
    XCTAssert(!(splitter >> str));

    splitter.split("::abc:,def:,ghi::", "::");
    XCTAssert(splitter >> str && str == "abc:,def:,ghi");
    XCTAssert(!(splitter >> str));

    splitter.split("abc def", " ");
    XCTAssert(splitter >> str && str == "abc");
    XCTAssert(splitter >> str && str == "def");
    XCTAssert(!(splitter >> str));

    str = "begin%20%20first%2second%0third20%end";
    string::translate(str, "%20", " ");
    XCTAssert(str == "begin  first%2second%0third20%end");

    std::vector<std::string> a;

    a.push_back("abc");
    a.push_back("def");
    a.push_back("ghi");
    a.push_back("jkl");

    XCTAssert(string::join(a) == "abc def ghi jkl");
    XCTAssert(string::join(a, "/") == "abc/def/ghi/jkl");

    splitter.split("abc 123 3.14");
    int ivalue;
    double dvalue;
    XCTAssert(splitter >> str && str == "abc");
    XCTAssert(splitter >> ivalue && ivalue == 123);
    XCTAssert(splitter >> dvalue && dvalue == 3.14);
}

@end
