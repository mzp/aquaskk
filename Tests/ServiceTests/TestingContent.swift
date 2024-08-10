//
//  TestingContent.swift
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

import Foundation

class TestingContent {
    static var bundle: Bundle {
        Bundle(for: TestingContent.self)
    }

    static var resourcePath: String {
        bundle.resourcePath!
    }

    static func writableCopy(path: String) throws -> String {
        let source = URL(fileURLWithPath: path)
        let destination = URL(fileURLWithPath: NSTemporaryDirectory()).appending(path: source.lastPathComponent)

        try FileManager.default.removeItem(at: destination)
        try FileManager.default.copyItem(at: source, to: destination)
        return destination.path()
    }
}
