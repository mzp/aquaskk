//
//  SKKFrontEndProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

import Foundation

@objc public protocol SKKFrontEndProtocol {
    @objc(insertString:)
    func insert(string: String)

    @objc func composeString(_ string: String, cursorOffset: Int)

    @objc func composeString(_ string: String,
                             candidateStart: Int, candidateLength: Int)

    @objc func selectedString() -> String
}
