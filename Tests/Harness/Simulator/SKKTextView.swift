//
//  SKKTextView.swift
//  AquaSKKIM
//
//  Created by mzp on 8/3/24.
//

import AppKit
import AquaSKKIM_Private
import Foundation
import InputMethodKit
import OSLog
import SwiftUI

private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "TextView")
private let signposter = OSSignposter(subsystem: "org.codefirst.AquaSKK.Harness", category: "TextView")

class SKKTextViewAppKit: NSTextView {
    private var controller: SKKInputController?
    private var client: IMKTextInput?

    func setup(controller: SKKInputController, stateStore: SKKStateStore) {
        let client = InputMethodKitAdapter(inputClient: self, stateStore: stateStore)
        controller._setClient(client)

        self.controller = controller
        self.client = client
    }

    override func keyDown(with event: NSEvent) {
        logger.info("\(#function): \(event)")

        var handled = false
        if let controller = controller, let client = client {
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
    var stateStore: SKKStateStore

    func makeNSView(context _: Context) -> SKKTextViewAppKit {
        let view = SKKTextViewAppKit()
        view.setup(controller: controller, stateStore: stateStore)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = NSSize(width: 10, height: 10)
        view.font = NSFont.systemFont(ofSize: 16)
        view.string = "Try me"
        return view
    }

    func updateNSView(_: SKKTextViewAppKit, context _: Context) {
//        textView.setup(controller: controller, stateStore: stateStore)
    }
}
