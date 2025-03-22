//
//  SKKPrimaryEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/04.
//

public class SKKPrimaryEditorImpl: SKKEditorProtocol {
    let context: SKKInputContext

    public init(context: SKKInputContext) {
        self.context = context
    }

    public func readContext() {
        context.entry = SKKEntry()
        var registration = context.registration
        if registration.state == .Finished {
            context.output.Fix(registration.word)
            registration.Clear()
        }
    }

    public func writeContext() {}

    public func input(ascii _: String) {
        context.event_handled = false
    }

    public func input(fixed: String, input _: String, code _: Int) {
        context.output.Fix(std.string(fixed))
    }

    public func bridgeInputEvent(_ rawValue: UInt32) {
        let event = SKKBaseEditorEvent(rawValue: rawValue)
        inputEvent(event: event)
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
