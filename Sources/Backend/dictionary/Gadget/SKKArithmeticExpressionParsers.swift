//
//  SKKArithmeticExpressionParsers.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/15/25.
//

/// expression = term { ('+' | '-') term };
/// term       = primary { ('*' | '/' | '%' ) primary };
/// primary    = [ '+' | '-' ] number | '(' expression ')';
/// number     = floating-point-literal;
class SKKArithmeticExpressionParsers: SKKParsersBase {
    enum Token: Equatable, Hashable {
        case keywoard(kind: String)
        case number(value: Float)
    }

    var savedToken: Token?
    func save(token: Token) throws {
        if savedToken != nil {
            throw SKKCalculatorError.fatal
        }
        savedToken = token
    }

    func getToken() throws -> Token {
        if let savedToken = savedToken {
            self.savedToken = nil
            return savedToken
        }
        if let kind = try? oneOf("()+-*/%") {
            return .keywoard(kind: String(kind))
        } else if peek(with: { try oneOf(".0123456789") }) != nil {
            let int = String(many { try oneOf("0123456789") })

            let string: String
            if (try? expect(character: ".")) != nil {
                let fraction = String(many { try oneOf("0123456789") })
                string = "\(int).\(fraction)"
            } else {
                string = int
            }
            if let value = Float(string) {
                return .number(value: value)
            } else {
                throw SKKCalculatorError.invalidCharacter
            }
        } else {
            throw SKKCalculatorError.invalidCharacter
        }
    }

    func expression() throws -> Float {
        var left = try term()
        var token = try? getToken()

        while true {
            switch token {
            case .keywoard(kind: "+"):
                left += try term()
            case .keywoard(kind: "-"):
                left -= try term()
            default:
                if let token = token {
                    try save(token: token)
                }
                return left
            }
            token = try? getToken()
        }
    }

    func term() throws -> Float {
        var left = try primary()
        var token = try? getToken()

        while true {
            switch token {
            case .keywoard(kind: "*"):
                left *= try primary()

            case .keywoard(kind: "/"):
                let divisor = try primary()
                if divisor == 0 {
                    throw SKKCalculatorError.zeroDivision
                }
                left /= divisor

            case .keywoard(kind: "%"):
                left = try fmodf(left, primary())

            default:
                if let token = token {
                    try save(token: token)
                }
                return left
            }
            token = try? getToken()
        }
    }

    func primary() throws -> Float {
        switch try getToken() {
        case .keywoard(kind: "("):
            // group
            let value = try expression()
            if case .keywoard(kind: ")") = try? getToken() {
                return value
            } else {
                throw SKKCalculatorError.invalidCharacter
            }

        case let .number(value: value):
            return value

        case .keywoard(kind: "-"):
            return try -primary()

        case .keywoard(kind: "+"):
            return try primary()

        default:
            throw SKKCalculatorError.invalidCharacter
        }
    }
}
