//
//  SKKEditorProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

import Foundation

public protocol SKKEditorProtocol {
    /// SKKInputContext の情報で初期化
    ///
    /// 具象エディタは SKKInputContext の情報で初期化されることを期待される
    /// SKKInputContext への書き込みも許可
    func readContext()

    /// SKKInputContext に書き出し
    ///
    /// 出力文字列や、状態設定等を行う
    func writeContext()

    /// 入力処理(ASCII もしくはペースト用)
    func input(ascii: String)

    /// 入力処理(fixed=確定文字列, input=入力文字列, code=入力文字)
    func input(fixed: String, input: String, code: CChar)

    /// 入力処理(event=イベント)
    func inputEvent(event: SKKBaseEditorEvent)

    /// 確定処理
    ///
    /// queue に確定した文字列をセットする
    func commit(queue: String) -> String
}
