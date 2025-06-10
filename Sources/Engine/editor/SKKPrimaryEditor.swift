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
        if let registration = context.registration,
             registration.state == .Finished {
            context.output.fix(string: registration.word)
            registration.clear()
        }
    }

    public func writeContext() {}

    public func input(ascii _: String) {
        context.event_handled = false
    }

    public func input(fixed: String, input _: String, code _: Int) {
        context.output.fix(string: fixed)
    }

    public func bridgeInputEvent(_ rawValue: UInt32) {
        let event = SKKBaseEditorEvent(rawValue: rawValue)
        inputEvent(event: event)
    }

    public func inputEvent(event _: SKKBaseEditorEvent) {
        context.event_handled = false
    }

    public func commit(queue: String) -> String {
        context.output.fix(string: queue)
        context.entry = SKKEntry()
        return ""
    }

    public var isPrimaryEditor: Bool {
        return true
    }
}
