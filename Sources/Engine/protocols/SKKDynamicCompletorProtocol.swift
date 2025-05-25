//
//  SKKDynamicCompletorProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

import Foundation

@objc public protocol SKKDynamicCompletorProtocol: SKKWidgetProtocol {
    @objc func update(completion: String, commonPrefixLength: Int, cursorOffset: Int)
}
