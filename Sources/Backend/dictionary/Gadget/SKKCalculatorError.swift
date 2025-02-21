//
//  SKKCalculatorError.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/15/25.
//

public enum SKKCalculatorError: Error {
    case invalidCharacter
    case zeroDivision
    case fatal

    var localizedDescription: String {
        switch self {
        case .invalidCharacter:
            return "計算エラー:不正な文字です"
        case .zeroDivision:
            return "計算エラー:ゼロ除算です"
        case .fatal:
            return "fatal error"
        }
    }
}
