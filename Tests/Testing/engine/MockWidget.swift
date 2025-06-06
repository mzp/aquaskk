//
//  MockWidget.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//

internal import AquaSKKEngine

class MockWidget: SKKWidgetProtocol {
    var visible: Bool = false
    func skkWidgetShow() {
        visible = true
    }

    func skkWidgetHide() {
        visible = false
    }
}
