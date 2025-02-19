//
//  SKKCalculator.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/15/25.
//

import Foundation

@objc(SKKCalculator)
public class SKKCalculator: NSObject {
    @objc public static let engine = SKKCalculator()

    public func run(_ expression: String) throws -> Float {
        let parser = SKKArithmeticExpressionParsers(source: expression)
        return try parser.expression()
    }

    @objc(run:error:) public func objcBridgeRun(_ str: String) throws -> NSNumber {
        return try .init(value: run(str))
    }
}
