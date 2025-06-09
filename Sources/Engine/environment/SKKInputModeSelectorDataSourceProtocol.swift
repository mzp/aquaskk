//
//  SKKInputModeSelectorDataSourceProtocol.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/09.
//

@objc public protocol SKKInputModeSelectorDataSourceProtocol {
    @objc var listeners: [SKKInputModeListenerProtocol] { get }
}
