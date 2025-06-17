//
//  MockDynamicCompletorImpl.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//
import AquaSKKEngine

class MockDynamicCompletorImpl: MockWidget, SKKDynamicCompletorProtocol {
    var completion: String = ""
    var commonPrefixLength: Int = 0
    var cursorOffset: Int = 0

    func update(completion: String, commonPrefixLength: Int, cursorOffset: Int) {
        self.completion = completion
        self.commonPrefixLength = commonPrefixLength
        self.cursorOffset = cursorOffset
    }
}
