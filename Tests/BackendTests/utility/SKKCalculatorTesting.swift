//
//  SKKCalculatorTesting.swift
//  AquaSKKEngineTests
//
//  Created by mzp on 7/31/24.
//

@testable internal import AquaSKKBackend
import Testing

struct SKKCalculatorTesting {
    @Test func token() throws {
        #expect(try SKKExpressionParser(source: "+").getToken() == .keywoard(kind: "+"))
        #expect(try SKKExpressionParser(source: "%").getToken() == .keywoard(kind: "%"))

        #expect(try SKKExpressionParser(source: "100").getToken() == .number(value: 100))
        #expect(try SKKExpressionParser(source: "1.23").getToken() == .number(value: 1.23))

        #expect(throws: SKKCalculatorError.self) {
            try SKKExpressionParser(source: "abc").getToken()
        }
    }

    @Test func primary() throws {
        let calc = SKKCalculator.engine
        #expect(try calc.run("100") == 100)
        #expect(try calc.run("100.") == 100)
        #expect(try calc.run("100.0") == 100)
        #expect(try calc.run(".1") == 0.1)
        #expect(try calc.run("-.1") == -0.1)
    }

    @Test func expression() throws {
        let calc = SKKCalculator.engine
        #expect(try calc.run("1+2") == 3)
        #expect(try calc.run("1.2-0.2") == 1)
    }

    @Test func term() throws {
        let calc = SKKCalculator.engine
        #expect(try calc.run("4*.3") == 1.2)
        #expect(try calc.run("300/50") == 6)
        #expect(try calc.run("4%2") == 0)
        #expect(try calc.run("9.6/2") == 4.8)
    }

    @Test func complex() throws {
        let calc = SKKCalculator.engine
        #expect(try calc.run("3+2*5") == 13)
        #expect(try calc.run("(3+2)*5") == 25)
    }

    @Test func error() throws {
        let calc = SKKCalculator.engine
        #expect(throws: SKKCalculatorError.self) {
            try calc.run("1/0")
        }
        #expect(throws: SKKCalculatorError.self) {
            try calc.run("(")
        }
        #expect(throws: SKKCalculatorError.self) {
            try calc.run("SKK")
        }
    }
}
