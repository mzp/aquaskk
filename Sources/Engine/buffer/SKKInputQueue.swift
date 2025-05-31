//
//  SKKInputQueue.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/03.
//

import AquaSKKLogging
import OSLog

public class SKKInputQueueImpl {
    private var inputMode: SKKInputMode
    private var observer: SKKInputQueueObserverProtocol {
        bridgedObserver.getInputQueueObserverProtocol()
    }

    private var bridgedObserver: SKKInputQueueObserver
    private var queue: String

    public init(observer: SKKInputQueueObserver) {
        inputMode = .HirakanaInputMode
        bridgedObserver = observer
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

    /// 文字の追加
    public func addChar(character: Int, direct: Bool) {
        let converter = RomanKanaConverterImpl.sharedInstance
        var state = SKKInputQueueObserverState()

        if direct || inputMode == .AsciiInputMode {
            if let newElement = Unicode.Scalar(UInt32(character)) {
                state.fixed = std.string(String(newElement))
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
                    state.fixed = std.string(result.output)
                    state.intermediate = std.string(result.intermediate)
                    queue = result.next
                }

            case .Jisx0208LatinInputMode:
                // ASCII → 全角英数変換
                if let newElement = Unicode.Scalar(UInt32(character)) {
                    queue += String(newElement)
                }
                let output = queue.applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? queue
                state.fixed = std.string(output)
                queue.removeAll()

            default:
                ()
            }
        }
        state.queue = std.string(queue)
        state.code = CChar(character)

        observer.bridgeInputQueueUpdate(
            fixed: String(state.fixed),
            intermediate: String(state.intermediate),
            queue: String(state.queue),
            code: Int(state.code)
        )
    }

    /// 文字の削除
    public func removeChar() {
        guard !isEmpty else {
            return
        }
        queue.removeLast()

        var state = SKKInputQueueObserverState()
        state.queue = std.string(queue)
        state.code = 0
        observer.bridgeInputQueueUpdate(fixed: String(state.fixed), intermediate: String(state.intermediate), queue: String(state.queue), code: Int(state.code))
    }

    /// 中間状態を確定させる(n → ん)
    public func terminate() {
        guard !isEmpty else {
            return
        }
        let converter = RomanKanaConverterImpl.sharedInstance
        var state = SKKInputQueueObserverState()

        switch inputMode {
        case .HirakanaInputMode,
             .Jisx0201KanaInputMode,
             .KatakanaInputMode:
            if let result = converter.convert(queue, inputMode: inputMode) {
                state.fixed = std.string(result.output + result.intermediate)
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
        observer.bridgeInputQueueUpdate(fixed: String(state.fixed), intermediate: String(state.intermediate), queue: String(state.queue), code: Int(state.code))
    }

    public func clear() {
        queue.removeAll()
        let state = SKKInputQueueObserverState()
        observer.bridgeInputQueueUpdate(fixed: String(state.fixed), intermediate: String(state.intermediate), queue: String(state.queue), code: Int(state.code))
    }

    public var isEmpty: Bool {
        return queue.isEmpty
    }

    public var queryString: String {
        return queue
    }

    /// 変換可能かどうか
    public func canConvert(code: Int) -> Bool {
        let converter = RomanKanaConverterImpl.sharedInstance

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
