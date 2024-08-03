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

class SKKTextViewImpl: NSTextView {
    lazy var client: IMKTextInput = SKKAdapter(inputClient: self)

    var controller: SKKInputController? {
        didSet {
            self.controller?._setClient(client)
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
    func makeNSView(context _: Context) -> SKKTextViewImpl {
        let view = SKKTextViewImpl()
        view.controller = controller
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func updateNSView(_ textView: SKKTextViewImpl, context _: Context) {
        textView.controller = controller
    }
}
