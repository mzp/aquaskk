//
//  MockFrontEndImpl.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//
import AquaSKKEngine

class MockFrontEndImpl: MockWidget, SKKFrontEndProtocol, SKKInputModeListenerProtocol {
    var fixed: String = ""
    var marked: String = ""
    var pos: Int = 0
    var mode: SKKInputMode = .InvalidInputMode

    func insert(string: String) {
        fixed += string
    }

    func composeString(_ string: String, cursorOffset: Int) {
        marked = string
        pos = cursorOffset
    }

    func composeString(_ string: String, candidateStart _: Int, candidateLength _: Int) {
        marked = string
        pos = 0
    }

    func selectInputMode(_ inputMode: SKKInputMode) {
        mode = inputMode
    }

    var string: String = ""
    func selectedString() -> String {
        string
    }

    func setSelectedString(_ string: String) {
        self.string = string
    }
}
