//
//  SKKInputQueue.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/03.
//

import AquaSKKLogging
import CxxStdlib
import Foundation
import OSLog

public class SKKInputQueueImpl {
    private var inputMode: SKKInputMode
    weak var observer: SKKInputQueueObserverProtocol?
    private var queue: String

    public init() {
        inputMode = .HirakanaInputMode
        queue = ""
    }

    /// 入力モードを変更する
    public func bridgedSelectInputMode(_ inputMode: Int32) {
        if let inputMode = SKKInputMode(rawValue: inputMode) {
            selectInputMode(inputMode: inputMode)
        }
    }

    /// 入力モードを変更する
    public func selectInputMode(inputMode: SKKInputMode) {
        self.inputMode = inputMode
        clear()
    }

    public func addChar(character: Character, direct: Bool) {
        addChar(character: Int(character.asciiValue ?? 0), direct: direct)
    }

    /// 文字の追加
    public func addChar(character: Int, direct: Bool) {
        let converter = SKKRomanKanaConverterImpl.sharedInstance
        var state = SKKInputQueueObserverState()

        if direct || inputMode == .AsciiInputMode {
            if let newElement = Unicode.Scalar(UInt32(character)) {
                state.fixed = String(newElement)
            }

        } else {
            switch inputMode {
            case .HirakanaInputMode,
                 .Jisx0201KanaInputMode,
                 .KatakanaInputMode:
                // ローマ字 → かな変換
                if let newElement = Unicode.Scalar(UInt32(character)) {
                    queue += String(newElement).lowercased()
                }
                if let result = converter.convert(queue, inputMode: inputMode), result.converted {
                    state.fixed = result.output
                    state.intermediate = result.intermediate
                    queue = result.next
                }

            case .Jisx0208LatinInputMode:
                // ASCII → 全角英数変換
                if let newElement = Unicode.Scalar(UInt32(character)) {
                    queue += String(newElement)
                }
                let output = queue.applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? queue
                state.fixed = output
                queue.removeAll()

            default:
                ()
            }
        }
        state.queue = queue
        state.code = character

        inputQueueUpdate(state: state)
    }

    func inputQueueUpdate(state: SKKInputQueueObserverState) {
        guard let observer = observer else {
            return
        }
        let fixed = state.fixed
        let intermediate = state.intermediate
        let queue = state.queue
        let code = state.code

        observer.bridgeInputQueueUpdate(
            fixed: fixed,
            intermediate: intermediate,
            queue: queue,
            code: code
        )
    }

    /// 文字の削除
    public func removeChar() {
        guard !isEmpty else {
            return
        }
        queue.removeLast()

        var state = SKKInputQueueObserverState()
        state.queue = queue
        state.code = 0
        inputQueueUpdate(state: state)
    }

    /// 中間状態を確定させる(n → ん)
    public func terminate() {
        guard !isEmpty else {
            return
        }
        let converter = SKKRomanKanaConverterImpl.sharedInstance
        var state = SKKInputQueueObserverState()

        switch inputMode {
        case .HirakanaInputMode,
             .Jisx0201KanaInputMode,
             .KatakanaInputMode:
            if let result = converter.convert(queue, inputMode: inputMode) {
                state.fixed = result.output + result.intermediate
            }

        case .AsciiInputMode,
             .Jisx0208LatinInputMode:
            break

        case .InvalidInputMode:
            Logger.skkEngine.fault("\(#function, privacy: .public) invalid input mode")

        @unknown default:
            Logger.skkEngine.fault("\(#function, privacy: .public) unknown input mode")
        }

        queue.removeAll()
        state.code = 0
        inputQueueUpdate(state: state)
    }

    public func clear() {
        queue.removeAll()
        let state = SKKInputQueueObserverState()
        inputQueueUpdate(state: state)
    }

    public var isEmpty: Bool {
        return queue.isEmpty
    }

    public var queryString: String {
        return queue
    }

    /// 変換可能かどうか
    public func canConvert(code: Int) -> Bool {
        let converter = SKKRomanKanaConverterImpl.sharedInstance

        switch inputMode {
        case .HirakanaInputMode,
             .Jisx0201KanaInputMode,
             .KatakanaInputMode:
            var tmpQueue = queue
            if let newElement = Unicode.Scalar(UInt32(code)) {
                tmpQueue += String(newElement).lowercased()
            }
            let result = converter.convert(tmpQueue, inputMode: inputMode)
            return result?.converted ?? false

        case .AsciiInputMode,
             .Jisx0208LatinInputMode:
            ()

        case .InvalidInputMode:
            Logger.skkEngine.fault("\(#function, privacy: .public) invalid input mode")
            return false

        @unknown default:
            Logger.skkEngine.fault("\(#function, privacy: .public) unknown input mode")
            return false
        }
        return false
    }
}
