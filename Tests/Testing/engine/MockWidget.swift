//
//  MockWidget.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//

import AquaSKKEngine

class MockWidget: SKKWidgetProtocol {
    func show() {
        skkWidgetShow()
    }

    func hide() {
        skkWidgetHide()
    }

    func activate() {
        skkWidgetShow()
    }

    func deactivate() {
        skkWidgetHide()
    }

    var visible: Bool = false
    func skkWidgetShow() {
        visible = true
    }

    func skkWidgetHide() {
        visible = false
    }
}
