//
//  MacMessenger.swift
//  AquaSKKInput
//
//  Created by mzp on 2/6/25.
//

import AppKit
import AquaSKKService
import AquaSKKUI

public class MacMessengerImpl: NSObject {
    let layoutManager: SKKLayoutManagerImpl

    @objc(initWithLayoutManager:)
    public init(layoutManager: SKKLayoutManagerImpl) {
        self.layoutManager = layoutManager
    }

    @objc public func send(message: String) {
        let window = MessengerWindow.shared()

        var topLeft = layoutManager.inputOrigin()
        topLeft.y -= 2

        window.showMessage(message, at: topLeft, level: layoutManager.windowLevel())
    }

    @objc public func beep() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: SKKUserDefaultKeys.beep_on_registration) {
            NSSound.beep()
        }
    }
}
