//
//  SKKInputModeListenerProtocol.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/05/24.
//

import AquaSKKBackend

@objc public protocol SKKInputModeListenerProtocol: SKKWidgetProtocol {
    @objc func selectInputMode(_ inputMode: SKKInputMode)
}
