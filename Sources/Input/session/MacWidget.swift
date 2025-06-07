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
        skkWidgetShow()
    }

    @objc public func activate() {
        skkWidgetShow()
    }

    @objc public func deactivate() {
        skkWidgetHide()
    }
}
