//
//  SKKMessengerProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

import Foundation

@objc public protocol SKKMessengerProtocol {
    @objc func send(message: String)
    @objc func beep()
}
