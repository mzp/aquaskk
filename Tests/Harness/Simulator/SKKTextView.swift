//
//  SKKTextView.swift
//  AquaSKKIM
//
//  Created by mzp on 8/3/24.
//

import AppKit
import AquaSKKIM
import Foundation
import InputMethodKit
import OSLog
import SwiftUI

private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "TextView")
private let signposter = OSSignposter(subsystem: "org.codefirst.AquaSKK.Harness", category: "TextView")

class SKKTextViewAppKit: NSTextView {
    lazy var client: IMKTextInput = SKKTextInputAppKit(inputClient: self)

    var controller: SKKInputController? {
        didSet {
            controller?._setClient(client)
            logger.info("\(self): Connected to \(self.controller)")
        }
    }

    override func keyDown(with event: NSEvent) {
        logger.info("\(#function): \(event)")

        var handled = false
        if let controller = controller {
            signposter.withIntervalSignpost("event handle") {
                handled = controller.handle(event, client: client)
            }
        }
        if !handled {
            super.keyDown(with: event)
        }
    }
}

struct SKKTextView: NSViewRepresentable {
    var controller: SKKInputController
    func makeNSView(context _: Context) -> SKKTextViewAppKit {
        let view = SKKTextViewAppKit()
        view.controller = controller
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = NSSize(width: 10, height: 10)
        view.font = NSFont.systemFont(ofSize: 16)
        view.string = "Try me"
        return view
    }

    func updateNSView(_ textView: SKKTextViewAppKit, context _: Context) {
        textView.controller = controller
    }
}
