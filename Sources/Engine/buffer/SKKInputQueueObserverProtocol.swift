//
//  SKKInputQueueObserverProtocol.swift
//  AquaSKK
//
//  Created by mzp on 2025/05/31.
//

import Foundation

@objc public protocol SKKInputQueueObserverProtocol {
    @objc func bridgeInputQueueUpdate(fixed: String, intermediate: String, queue: String, code: Int)
}
