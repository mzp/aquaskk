//
//  MacWidget.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/07.
//
import Foundation

open class SKKWidgetBase: NSObject {
    private var visible: Bool
    public init(visible: Bool = false) {
        self.visible = visible
    }

    open func skkWidgetShow() {}

    open func skkWidgetHide() {}

    @objc public func show() {
        visible = true
        skkWidgetShow()
    }

    @objc public func hide() {
        visible = false
        skkWidgetHide()
    }

    @objc public func activate() {
        if visible {
            skkWidgetShow()
        }
    }

    @objc public func deactivate() {
        if visible {
            skkWidgetHide()
        }
    }
}
