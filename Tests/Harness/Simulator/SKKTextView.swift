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

private let logger = Logger(subsystem: "com.aquaskk.inputmethod", category: "TextView")
private let signposter = OSSignposter(subsystem: "com.aquaskk.inputmethod", category: "TextView")

class SKKTextViewAppKit: NSTextView {
    private var controller: SKKInputController?
    private var client: InputMethodKitAdapter?

    func setup(controller: SKKInputController, store: SKKStateStore) {
        let client = InputMethodKitAdapter(inputClient: self, store: store)
        controller._setClient(client)

        self.controller = controller
        self.client = client
    }

    func update(store: SKKStateStore) {
        guard let client = client else {
            logger.error("\(#function): can't find input client")
            return
        }
        guard let controller = controller else {
            logger.error("\(#function): can't find input controller")
            return
        }
        client.store = store
        controller.setValue(store.modeIdentifier, forTag: kTextServiceInputModePropertyTag, client: client)
    }

    func setInputMode(_ value: String) {
        controller?.setValue(value, forTag: kTextServiceInputModePropertyTag, client: client)
    }

    override func keyDown(with event: NSEvent) {
        logger.log("\(#function): \(event)")

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
    @Binding var store: SKKStateStore

    func makeNSView(context _: Context) -> SKKTextViewAppKit {
        let view = SKKTextViewAppKit()
        view.setup(controller: controller, store: store)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = NSSize(width: 10, height: 10)
        view.font = NSFont.systemFont(ofSize: 16)
        view.string = "Try me"
        return view
    }

    func updateNSView(_ textView: SKKTextViewAppKit, context _: Context) {
        textView.update(store: store)
    }
}
