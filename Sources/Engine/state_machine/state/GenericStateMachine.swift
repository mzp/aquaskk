//
//  GenericStateMachine.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

class GenericStateMachine {
    init(top: HandlerProtocol, inspector: InspectorProtocol, bridgePerform: @escaping (SKKStateMachineAction, GenericState) -> GenericState?) {
        self.inspector = inspector
        self.top = top
        self.bridgePerform = bridgePerform
    }

    var inspector: any InspectorProtocol
    var top: HandlerProtocol
    var active: HandlerProtocol?
    var bridgePerform: (SKKStateMachineAction, GenericState) -> GenericState?

    var queue = GenericDeferEventQueue()
    var history: GenericStateHistory = .init()

    // MARK: - invoke state function

    func invoke(handler: HandlerProtocol, event: GenericEvent) -> GenericState? {
        inspector.inspect(handler: handler, event: event)
        let bridgeEvent: SKKStateMachineEvent
        if let payload = event.event {
            bridgeEvent = .init(event.signal.rawValue, payload)
        } else {
            bridgeEvent = .init(event.signal.rawValue)
        }
        let result = handler.dispatch(event: bridgeEvent)
        return bridgePerform(result, .super_(handler: handler.super_ ?? top))
    }

    // MARK: - system event trigger

    func getSuperState(handler: HandlerProtocol) -> GenericState? {
        return invoke(handler: handler, event: .probe)
    }

    func entryAction(handler: HandlerProtocol) -> GenericState? {
        return invoke(handler: handler, event: .entry)
    }

    func initialTransition(handler: HandlerProtocol) -> GenericState? {
        return invoke(handler: handler, event: .init_)
    }

    var prior: HandlerProtocol?
    func exitAction(handler: HandlerProtocol) -> GenericState? {
        let result = invoke(handler: handler, event: .exit)

        if result?.type == .saveHistory {
            history.save(key: handler, shallow: prior, deep: active)
        }
        queue.commit(key: handler)
        prior = handler
        return result
    }

    // MARK: - initial transition trigger

    func initialize(target: GenericState) {
        var active = target.handler
        self.active = active

        guard var state = self.initialTransition(handler: active) else {
            return
        }

        while state.type == .initial ||
                state.type == .shalllowHistory
        {
            if state.type == .shalllowHistory {
                if let shallow = history.shallow(key: active) {
                    active = shallow
                } else {
                    // first time
                    history.save(key: active, shallow: state.handler, deep: nil)
                    active = state.handler
                }
            } else {
                active = state.handler
            }
            self.active = active
            _ = entryAction(handler: active)

            guard let nextState = self.initialTransition(handler: active) else {
                return
            }
            state = nextState
        }
    }

    // MARK: - transition trigger

    func transition(source: HandlerProtocol, target: HandlerProtocol) {
        prior = nil

        guard let active = active else {
            return
        }

        // exit to source
        for tmp in sequence(first: active, next: {
            self.getSuperState(handler: $0)?.handler
        }) {
            _ = exitAction(handler: tmp)
        }

        var path = [HandlerProtocol]()
        // go into the target
        defer {
            for handler in path.reversed() {
                _ = entryAction(handler: handler)
            }
        }

        // exit to LCA(Least Common Ancestor) and record the path to the target
        path.append(target)

        // (a) self transition
        if source.handlerID == target.handlerID {
            selfTransitionCount += 1
            _ = exitAction(handler: source)
            return
        }

        // (b) go into substate(one level)
        let targetSuper = getSuperState(handler: target)?.handler
        if targetSuper?.handlerID == source.handlerID {
            return
        }

        // (c) balanced transition
        let sourceSuper = getSuperState(handler: source)?.handler
        if sourceSuper?.handlerID == targetSuper?.handlerID {
            _ = exitAction(handler: source)
            return
        }

        // (d) leave from substate(one level)
        if sourceSuper?.handlerID == target.handlerID {
            _ = exitAction(handler: source)
            path.removeAll()
            return
        }

        // (e) go into substate(multiple level)
        if let targetSuper = targetSuper {
            for tmp in sequence(first: targetSuper, next: { self.getSuperState(handler: $0)?.handler }) {
                if tmp.handlerID == source.handlerID {
                    return
                } else {
                    path.append(targetSuper)
                }
            }
        }

        _ = exitAction(handler: source)

        // (f) unbalanced transition
        if let handlerID = sourceSuper?.handlerID, path.contains(where: { $0.handlerID == handlerID }) {
            return
        }

        // (g) leave from substate(multiple level)
        if let sourceSuper = sourceSuper {
            for tmp in sequence(first: sourceSuper, next: { self.getSuperState(handler: $0)?.handler }) {
                if path.contains(where: { $0.handlerID == tmp.handlerID }) {
                    break
                }
                _ = exitAction(handler: tmp)
            }
        }
    }

    public func start() {
        assert(active == nil, "*** You can not call Start() twice ***")
        initialize(target: GenericState.initial(handler: top))
    }

    var selfTransitionCount = 0
    public func dispatch(event: GenericEvent) {
        if active == nil {
            start()
        }
        selfTransitionCount = 0

        var source = active
        while source != nil {
            guard var next = invoke(handler: source!, event: event) else {
                return
            }
            switch next.type {
            case .deferEvent:
                queue.enqueue(key: source!, event: event)
                return
            case .clearHistory:
                history.clear(key: source!)
                return
            case .deepHistory:
                let target = history.deep(key: next.handler)!
                transition(source: source!, target: target)
                initialize(target: .super_(handler: target))

                for defer_ in sequence(state: queue, next: { $0.dequeue(key: source!) }) {
                    // recursion
                    dispatch(event: defer_)
                }
                return
            case .deepForward:
                let target = history.deep(key: next.handler)!
                transition(source: source!, target: target)
                initialize(target: .super_(handler: target))
                next = .super_(handler: target)
                source = next.handler
            case .transition:
                transition(source: source!, target: next.handler)
                initialize(target: next)

                for defer_ in sequence(state: queue, next: { $0.dequeue(key: source!) }) {
                    // recursion
                    dispatch(event: defer_)
                }
                return
            case .forward:
                transition(source: source!, target: next.handler)
                initialize(target: next)
                source = next.handler
            case .shalllowHistory, .saveHistory, .initial:
                fatalError("*** Invalid state detected ***")
            default:
                source = next.handler
            }

        }
    }
}
