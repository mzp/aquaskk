//
//  SKKOkuriEditorImpl.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

import Foundation

public class SKKOkuriEditorImpl {
    let context: SKKInputContext
    let listener: SKKOkuriListener
    var first: Bool
    var prefix: String
    var okuri: String
    var input: String

    public init(context: SKKInputContext, listener: SKKOkuriListener) {
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

    public func input(fixed: String, input: String, code: CChar) {
        self.input = input
        if first {
            first = false
            if let newElement = Unicode.Scalar(UInt32(code)) {
                prefix += String(newElement)
            }

            // KesSi 対応
            if !fixed.isEmpty, !input.isEmpty {
                listener.SKKOkuriListenerAppendEntry(std.string(fixed))
                update()
                return
            }
        }
        // fixed が ascii の場合には送りとはみなさない
        // 文字種で判断したいところだが、とりあえず長さで判断
        if fixed.count != fixed.count {
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

    public func commit(queue _: String) {
        prefix.removeAll()
        okuri.removeAll()
    }

    public func isOkuriComplete() -> Bool {
        return !okuri.isEmpty && input.isEmpty
    }

    private func update() {
        context.entry.SetOkuri(std.string(prefix), std.string(okuri))
    }
}
