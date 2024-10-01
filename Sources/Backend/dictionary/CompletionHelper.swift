//
//  CompletionHelper.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/15/24.
//

import Foundation

public protocol CompletionHelper {
    var entry: String { get }
    var canContinue: Bool { get }
    mutating func append(completion: String)
}
