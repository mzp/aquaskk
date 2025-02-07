//
//  MacMessenger.swift
//  AquaSKKInput
//
//  Created by mzp on 2/6/25.
//

import Foundation
import AppKit
import AquaSKKUI

public class MacMessengerImpl: NSObject {
    let layout: SKKLayoutManagerImpl

    @objc(initWithLayout:)
    public init(layout: SKKLayoutManagerImpl) {
        self.layout = layout
    }

    @objc @MainActor public func send(message: String) {
        let window = MessengerWindow.shared()

        var topLeft = layout.inputOrigin(index: 0)
        topLeft.y -= 2

        window.showMessage(message, at: topLeft, level: layout.windowLevel())

    }
    @objc public func beep() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: SKKUserDefaultKeys.beep_on_registration) {
            NSSound.beep()
        }
    }

}
