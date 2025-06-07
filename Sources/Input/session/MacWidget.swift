//
//  MacWidget.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/07.
//
import Foundation

public class MacWidget: NSObject {
    private var visible: Bool = false
    public func skkWidgetShow() {}

    public func skkWidgetHide() {}

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
