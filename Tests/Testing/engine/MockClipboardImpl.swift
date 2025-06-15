//
//  MockClipboardImpl.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//
import AquaSKKEngine

class MockClipboardImpl: SKKClipboardProtocol {
    var string: String = ""
    func pasteString() -> String {
        string
    }
}
