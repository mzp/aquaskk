//
//  SKKHandleOption.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/15.
//

/// 処理オプション
public struct SKKHandleOption: OptionSet {
    public let rawValue: Int
    public static let defalutOption = SKKHandleOption(rawValue: 0)

    /// 強制的に「処理済み」にする
    public static let alwaysHandled = SKKHandleOption(rawValue: 1 << 0)
    /// 処理は行うが「未処理」とする
    public static let pseudoHandled = SKKHandleOption(rawValue: 1 << 1)
    /// CapsLock
    public static let capsLock = SKKHandleOption(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
