//
//  SKKSelectorBuddyProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/29.
//

import Foundation

// SKKSelector の相棒クラス
@objc public protocol SKKSelectorBuddyProtocol {
    // SKKSelector::Execute() 時に呼び出される
    @objc func bridgeSelectorQueryEntry() -> [String]

    // SKKSelector で現在選択中の候補が変更された場合に呼び出される
    @objc func bridgeSelectorUpdate(candidate: String)
}
