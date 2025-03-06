//
//  SKKPrimaryEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/04.
//

import Foundation

public class SKKPrimaryEditorImpl {
    let context: SKKInputContext

    public init(context: SKKInputContext) {
        self.context = context
    }

    public func readContext() {
        context.entry = SKKEntry()
        var registration = context.registration
        if registration.state == SKKRegistrationFinished {
            context.output.Fix(registration.word)
            registration.Clear()
        }
    }

    public func input(ascii _: String) {
        context.event_handled = false
    }

    public func input(fixed: String, input _: String, code _: CChar) {
        context.output.Fix(std.string(fixed))
    }

    public func inputEvent(event _: SKKBaseEditorEvent) {
        context.event_handled = false
    }

    public func commit(queue: String) -> String {
        context.output.Fix(std.string(queue))
        context.entry = SKKEntry()
        return ""
    }
}
