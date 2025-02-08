//
//  MacInputModeMenu.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//


@objc(MacInputModeMenuImpl)
public class MacInputModeMenuImpl: NSObject {
    private let menu: SKKInputMenu
    private var active: Bool

    @objc public init(menu: SKKInputMenu) {
        self.menu = menu
        self.active = false
        super.init()
    }

    @MainActor @objc public func selectInputMode(_ inputMode: SKKInputMode) {
        if active {
            menu.updateMenu(inputMode)
        }
    }

    @objc public func skkWidgetShow() {
        active = true
    }

    @objc public func skkWidgetHide() {
        active = false
    }
}
