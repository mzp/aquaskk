//
//  SendableText.swift
//  TyperTests
//
//  Created by mzp on 8/13/24.
//

import Foundation

struct SendableText: Equatable, Sendable {
    var string: String = ""
    var marked: String = ""
    var markedTextRange: NSRange = .init(location: 0, length: 0)
    var modeIdentifier: String? = nil

    mutating func clear() {
        string = ""
        marked = ""
        markedTextRange = .init(location: 0, length: 0)
    }
}
