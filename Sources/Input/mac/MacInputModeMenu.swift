//
//  MacInputModeMenu.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import AquaSKKLogging
import OSLog

@objc(MacInputModeMenuImpl)
public class MacInputModeMenuImpl: MacWidget, SKKInputModeListenerProtocol {
    private let menu: SKKInputMenu
    private var active: Bool

    @objc public init(menu: SKKInputMenu) {
        self.menu = menu
        active = false
        super.init()
    }

    deinit {
        Logger.skkMemory.debug("\(#function, privacy: .public))")
    }

    @objc public func selectInputMode(_ inputMode: SKKInputMode) {
        if active {
            menu.updateMenu(inputMode)
        }
    }

    @objc override public func skkWidgetShow() {
        active = true
    }

    @objc override public func skkWidgetHide() {
        active = false
    }
}
