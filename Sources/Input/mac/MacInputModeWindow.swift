//
//  MacInputModeWindow.swift
//  AquaSKKInput
//
//  Created by mzp on 2/6/25.
//

import AquaSKKLogging
import AquaSKKService
import OSLog

@objc public class MacInputModeWindowImpl: NSObject, SKKInputModeListenerProtocol {
    private let layoutManager: SKKLayoutManager
    private let tips: SKKModeTipsImpl

    @objc(initWithLayoutManager:) public init(layoutManager: SKKLayoutManager) {
        self.layoutManager = layoutManager
        tips = SKKModeTipsImpl(layoutManager: layoutManager)
        super.init()
        Logger.skkMemory.debug("\(#function, privacy: .public))")
    }

    deinit {
        Logger.skkMemory.debug("\(#function, privacy: .public))")
    }

    @objc public func selectInputMode(_ inputMode: SKKInputMode) {
        tips.inputMode = inputMode
    }

    var enabled: Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: SKKUserDefaultKeys.show_input_mode_icon)
    }

    @objc public func skkWidgetShow() {
        guard enabled else {
            return
        }
        tips.show()
    }

    @objc public func skkWidgetHide() {
        tips.hide()
    }
}
