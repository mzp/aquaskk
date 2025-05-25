//
//  MacDynamicCompletor.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import AppKit
import AquaSKKUI

@objc(MacDynamicCompletorImpl)
public class MacDynamicCompletorImpl: NSObject, SKKDynamicCompletorProtocol {
    private let layoutManager: SKKLayoutManager
    private let window: CompletionWindow

    private var completion: String
    private var commonPrefixLength: Int
    private var cursorOffset: Int

    @objc public init(layoutManager: SKKLayoutManager) {
        self.layoutManager = layoutManager
        window = CompletionWindow()
        completion = ""
        commonPrefixLength = 0
        cursorOffset = 0
        super.init()
    }

    @objc public func update(completion: String, commonPrefixLength: Int, cursorOffset: Int) {
        self.completion = completion
        self.commonPrefixLength = commonPrefixLength
        self.cursorOffset = cursorOffset
    }

    @objc public func skkWidgetShow() {
        if completion.isEmpty {
            skkWidgetHide()
        } else {
            window.showCompletion(markedAttributedString, at: layoutManager.inputOrigin(index: cursorOffset + 1), level: layoutManager.windowLevel())
        }
    }

    @objc public func skkWidgetHide() {
        window.hide()
    }

    private var markedAttributedString: NSAttributedString {
        let result = NSMutableAttributedString(string: completion)
        result.addAttribute(.font, value: NSFont.systemFont(ofSize: 0), range: NSRange(location: 0, length: result.length))

        var diff = NSRange(location: -1, length: -1)
        repeat {
            diff.location += commonPrefixLength + 1
            if diff.location < result.length {
                result.setAttributes([:], range: diff)
            }
            let str = result.string as NSString

            diff = str.range(of: "\n", options: [], range: NSRange(location: 0, length: 0))
        } while diff.location != NSNotFound
        return result
    }
}
