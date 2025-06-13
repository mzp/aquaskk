//
//  SKKInputQueueObserverState.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/12.
//

import Foundation

/// 入力状態
public struct SKKInputQueueObserverState {
    /// 確定した文字
    public var fixed: String
    /// 最小マッチした文字
    public var intermediate: String
    /// 入力バッファ
    public var queue: String

    /// 入力文字
    public var code: Int

    public init(fixed: String, intermediate: String, queue: String, code: Int) {
        self.fixed = fixed
        self.intermediate = intermediate
        self.queue = queue
        self.code = code
    }

    public init() {
        self.init(fixed: "", intermediate: "", queue: "", code: 0)
    }
}
