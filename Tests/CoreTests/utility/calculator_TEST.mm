#include <cassert>
#include <iostream>
#import <XCTest/XCTest.h>
#include "calculator.h"

@interface CalculatorTests : XCTestCase
@end

@implementation CalculatorTests

- (void)testMain {
    calculator::engine calc;

    XCTAssert(calc.run("100") == 100);
    XCTAssert(calc.run("1+2") == 3);
    XCTAssert(calc.run("1.2-0.2") == 1);
    XCTAssert(calc.run("4*.3") == 1.2);
    XCTAssert(calc.run("300/50") == 6);
    XCTAssert(calc.run("4%2") == 0);
    XCTAssert(calc.run("9.6/2") == 4.8);
    XCTAssert(calc.run("3+2*5") == 13);
    XCTAssert(calc.run("(3+2)*5") == 25);
    try {
        calc.run("1/0");
        XCTAssert("divide by ZERO" && false);
    } catch(...) {
    }

    try {
        calc.run("(");
        XCTAssert("')' expected" && false);
    } catch(...) {
    }

    try {
        calc.run("a");
        XCTAssert("invalid characer" && false);
    } catch(...) {
    }

    try {
        calc.run("");
        XCTAssert("no data found" && false);
    } catch(...) {
    }
}

@end
