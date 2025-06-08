//
//  SKKInputModeSelector.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/08.
//

import Foundation

@objc public class SKKInputModeSelectorImpl: SKKWidgetBase, SKKWidgetProtocol {
    @objc public private(set) var inputMode: SKKInputMode

    private let listeners: [SKKInputModeListenerProtocol]
    private var needsUpdate: Bool
    @objc public init(listeners: [SKKInputModeListenerProtocol]) {
        inputMode = .InvalidInputMode
        self.listeners = listeners
        needsUpdate = false
        super.init(visible: true)

        select(inputMode: .HirakanaInputMode)
    }

    override public func skkWidgetShow() {
        listeners.forEach { $0.show() }
    }

    override public func skkWidgetHide() {
        listeners.forEach { $0.hide() }
    }

    @objc public func select(inputMode: SKKInputMode) {
        needsUpdate = (inputMode != self.inputMode)
        self.inputMode = inputMode
        for listener in listeners {
            listener.selectInputMode(inputMode)
        }
    }

    @objc public func notify() {
        if needsUpdate {
            needsUpdate = false
            skkWidgetShow()
        }
    }

    @objc public func refresh() {
        select(inputMode: inputMode)
        needsUpdate = true
    }
}
