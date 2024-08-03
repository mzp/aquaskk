//
//  CalculatorTesting.swift
//  AquaSKKEngineTests
//
//  Created by mzp on 7/31/24.
//

import AquaSKKCore
import Testing

struct CalculatorTesting {
    @Test func expression() {
        var calc = calculator.engine()
        #expect(calc.run("100") == 100)
        #expect(calc.run("1+2") == 3)
        #expect(calc.run("1.2-0.2") == 1)
        #expect(calc.run("4*.3") == 1.2)
        #expect(calc.run("300/50") == 6)
        #expect(calc.run("4%2") == 0)
        #expect(calc.run("9.6/2") == 4.8)
        #expect(calc.run("3+2*5") == 13)
        #expect(calc.run("(3+2)*5") == 25)
    }
}
