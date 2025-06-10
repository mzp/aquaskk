//
//  SKKInputSession.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/05.
//

import Foundation

@objc public class SKKInputSessionImpl: NSObject, SKKInputModeSelectorDataSourceProtocol {
    let param: SKKInputSessionParameterProtocol
    let context: SKKInputContext
    var stacks: [SKKRecursiveEditorImpl]
    let selector: SKKInputModeSelectorImpl

    @objc public init(param: SKKInputSessionParameterProtocol, context: SKKInputContext) {
        self.param = param
        self.context = context
        inEvent = false
        stacks = []
        selector = SKKInputModeSelectorImpl()
        super.init()
        selector.dataSource = self
        stacks.append(
            createEditor(editor: SKKPrimaryEditorImpl(context: context))
        )
    }

    deinit {
        while !stacks.isEmpty {
            popEditor()
        }
    }

    // MARK: - SKKInputModeSelectorDataSourceProtocol

    public private(set) var listeners: [SKKInputModeListenerProtocol] = []

    @objc public func addInputModeListener(_ listener: SKKInputModeListenerProtocol) {
        listeners.append(listener)
    }

    // MARK: - Editor stack

    var top: SKKRecursiveEditorImpl? {
        stacks.last
    }

    func createEditor(editor: SKKEditorProtocol) -> SKKRecursiveEditorImpl {
        let env = SKKInputEnvironmentImpl(
            context: context,
            param: param,
            selector: selector,
            isPrimaryEditor: editor.isPrimaryEditor
        )
        return SKKRecursiveEditorImpl(env: env)
    }

    func popEditor() {
        stacks.removeLast()
    }

    // MARK: - Event Handle

    @objc public func handle(event: SKKEvent) -> Bool {
        return handleEventIfNecessary(perform: {
            beginEvent()

            top?.input(event: event)

            endEvent()

            top?.output()

            return result(of: event)
        }) ?? false
    }

    func beginEvent() {
        context.event_handled = true
        context.needs_setback = false
    }

    func endEvent() {
        switch context.registration.state {
        case .Started:
            context.registration.Clear()

            stacks.append(
                createEditor(editor: SKKRegisterEditorImpl(context: context))
            )

        case .Finished:
            if stacks.count != 1 {
                popEditor()

                top?.input(event: SKKEvent(Int32(SKK_ENTER), 0, 0, 0))
            }

        case .Aborted:
            if stacks.count != 1 {
                popEditor()

                top?.input(event: SKKEvent(Int32(SKK_CANCEL), 0, 0, 0))
            }

        default:
            ()
        }
    }

    func result(of event: SKKEvent) -> Bool {
        // 単語登録中か、未確定状態なら常に処理済み
        if stacks.count != 1 || context.output.isComposing {
            return true
        }
        switch Int(event.option) {
        case AlwaysHandled:
            // 常に処理済み
            return true
        case PseudoHandled:
            // 未処理
            return false
        default:
            return context.event_handled
        }
    }

    // MARK: - Operation

    @objc public func commit() {
        let enter = SKKEvent(Int32(SKK_ENTER), 0, 0, 0)
        _ = handle(event: enter)

        if context.output.isComposing {
            clear()
        }
    }

    @objc public func clear() {
        handleEventIfNecessary {
            while !stacks.isEmpty {
                popEditor()
            }

            stacks.append(
                createEditor(editor: SKKPrimaryEditorImpl(context: context))
            )

            top?.output()
        }
    }

    @objc public func activate() {
        top?.activate()
    }

    @objc public func deactivate() {
        top?.deactivate()
    }

    // MARK: - Event

    private var inEvent: Bool
    func handleEventIfNecessary<T>(perform: () -> T) -> T? {
        guard inEvent == false else {
            return nil
        }
        defer { inEvent = false }
        inEvent = true
        return perform()
    }
}
