//
//  SKKOkuriEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

public class SKKOkuriEditorImpl: SKKEditorProtocol {
    let context: SKKInputContext
    let listener: SKKOkuriListenerProtocol
    var first: Bool
    var prefix: String
    var okuri: String
    var input: String

    public init(context: SKKInputContext, listener: SKKOkuriListenerProtocol) {
        self.context = context
        self.listener = listener
        first = false
        prefix = ""
        okuri = ""
        input = ""
    }

    public func readContext() {
        first = true
        prefix.removeAll()
        okuri.removeAll()
    }

    public func writeContext() {
        context.output.Compose(std.string("*\(okuri)"), 0)
        update()
    }

    public func input(ascii _: String) {}

    public func input(fixed: String, input: String, code: Int) {
        self.input = input
        if first {
            first = false
            if let newElement = Unicode.Scalar(UInt32(code)) {
                prefix += String(newElement)
            }

            // KesSi 対応
            if !fixed.isEmpty, !input.isEmpty {
                listener.okkuriListenerAppendEntry(fixed: fixed)
                update()
                return
            }
        }
        // fixed が ascii の場合には送りとはみなさない
        if !(fixed.first?.isASCII ?? true) {
            okuri += fixed
        }

        // OWsa 対応
        if okuri.isEmpty {
            prefix.removeAll()
            if input.isEmpty {
                if let newElement = Unicode.Scalar(UInt32(code)) {
                    prefix += String(newElement)
                }
            } else {
                if let newElement = input.lowercased().first {
                    prefix += String(newElement)
                }
            }
        } else {
            if prefix.isEmpty {
                if let newElement = Unicode.Scalar(UInt32(code)) {
                    prefix += String(newElement)
                }
            }
        }
        update()
    }

    public func bridgeInputEvent(_ rawValue: UInt32) {
        let event = SKKBaseEditorEvent(rawValue: rawValue)
        inputEvent(event: event)
    }

    public func inputEvent(event: SKKBaseEditorEvent) {
        if event == SKKBaseEditorEventBackSpace {
            if okuri.isEmpty {
                context.needs_setback = true
            } else {
                okuri.removeLast()
            }
        }
        update()
    }

    public func commit(queue: String) -> String {
        prefix.removeAll()
        okuri.removeAll()
        return queue
    }

    public func isOkuriComplete() -> Bool {
        return !okuri.isEmpty && input.isEmpty
    }

    private func update() {
        context.entry.SetOkuri(std.string(prefix), std.string(okuri))
    }
}
