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
    var modeIdentifier: String? = nil
    var keyboardLayout: String? = nil
}
