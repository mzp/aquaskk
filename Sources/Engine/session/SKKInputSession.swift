//
//  SKKInputSession.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/05.
//

import Foundation

@objc public class SKKInputSessionImpl: NSObject, SKKInputModeSelectorDataSourceProtocol {
    let param: SKKInputSessionParameterProtocol
    let context: SKKInputContextImpl
    var stacks: [SKKRecursiveEditorImpl]
    let selector: SKKInputModeSelectorImpl

    @objc public init(param: SKKInputSessionParameterProtocol) {
        self.param = param
        context = SKKInputContextImpl(frontend: param.frontEnd())
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
        var eventImpl = SKKEventImpl()
        eventImpl.id = .init(rawValue: event.id)!
        eventImpl.code = Int(event.code)
        eventImpl.attribute = .init(rawValue: Int(event.attribute))
        eventImpl.option = .init(rawValue: Int(event.option))
        return handle(event: eventImpl)
    }
    public func handle(event: SKKEventImpl) -> Bool {
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
            context.registration.clear()

            stacks.append(
                createEditor(editor: SKKRegisterEditorImpl(context: context))
            )

        case .Finished:
            if stacks.count != 1 {
                popEditor()

                top?.input(event: .init(id: .enter, code: 0, attribute: [], option: .defalutOption))
            }

        case .Aborted:
            if stacks.count != 1 {
                popEditor()
                top?.input(event: .init(id: .cancel, code: 0, attribute: [], option: .defalutOption))
            }

        default:
            ()
        }
    }

    func result(of event: SKKEventImpl) -> Bool {
        // 単語登録中か、未確定状態なら常に処理済み
        if stacks.count != 1 || context.output.isComposing {
            return true
        }
        switch event.option {
        case .alwaysHandled:
            // 常に処理済み
            return true
        case .pseudoHandled:
            // 未処理
            return false
        default:
            return context.event_handled
        }
    }

    // MARK: - Operation

    @objc public func commit() {
        _ = handle(event: .init(id: .enter, code: 0, attribute: [], option: .defalutOption))
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
