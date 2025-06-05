//
//  SKKAnnotatorProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

import AquaSKKBackend

@objc
public protocol SKKWidgetProtocol {
    @objc func skkWidgetShow()
    @objc func skkWidgetHide()
}

@objc
public protocol SKKAnnotatorProtocol: SKKWidgetProtocol {
    @objc(update:cursorOffset:)
    func update(candidateBridge bridge: SKKCandidateBridge, cursorOffset: Int)
}
