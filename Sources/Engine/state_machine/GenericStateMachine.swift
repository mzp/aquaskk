//
//  GenericStateMachine.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

class GenericStateMachine<Handler: HandlerProtocol, Inspector: InspectorProtocol> where Inspector.Handler == Handler {
    init() {
        fatalError()
    }

    var inspector: Inspector
    var top: Handler
    var active: Handler?

    var queue = GenericDeferEventQueue<Handler>()
    var history: GenericStateHistory<Handler> = .init()

    // MARK: - invoke state function

    func invoke(handler: Handler, event: GenericEvent) -> GenericState<Handler>? {
        inspector.inspect(handler: handler, event: event)
        return handler.invoke(event: event)
    }

    // MARK: - system event trigger

    func getSuperState(handler: Handler) -> GenericState<Handler>? {
        return invoke(handler: handler, event: .probe)
    }

    func entryAction(handler: Handler) -> GenericState<Handler>? {
        return invoke(handler: handler, event: .entry)
    }

    func initialTransition(handler: Handler) -> GenericState<Handler>? {
        return invoke(handler: handler, event: .init_)
    }

    var prior: Handler?
    func exitAction(handler: Handler) -> GenericState<Handler>? {
        let result = invoke(handler: handler, event: .exit)

        if result?.type == .saveHistory {
            history.save(key: handler, shallow: prior, deep: active)
        }
        queue.commit(key: handler)
        prior = handler
        return result
    }

    // MARK: - initial transition trigger

    func initialize(target: GenericState<Handler>) {
        var active = target.handler

        for state in sequence(state: active, next: { handler -> GenericState<Handler>? in
            guard let state = self.initialTransition(handler: handler) else {
                fatalError("*** Initial transition must be ended by returning super state ***")
            }
            switch state.type {
            case .initial,
                 .shalllowHistory:
                return state
            case .super_:
                return nil
            default:
                fatalError("*** Initial transition must be ended by returning super state ***")
            }
        }) {
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
            _ = entryAction(handler: active)
        }

        self.active = active
    }

    // MARK: - transition trigger

    func transition(source: Handler, target: Handler) {
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

        var path = [Handler]()
        // go into the target
        defer {
            for handler in path.reversed() {
                _ = entryAction(handler: handler)
            }
        }

        // exit to LCA(Least Common Ancestor) and record the path to the target
        path.append(target)

        // (a) self transition
        if source == target {
            selfTransitionCount += 1
            _ = exitAction(handler: source)
            return
        }

        // (b) go into substate(one level)
        let targetSuper = getSuperState(handler: target)?.handler
        if targetSuper == source {
            return
        }

        // (c) balanced transition
        let sourceSuper = getSuperState(handler: source)?.handler
        if sourceSuper == targetSuper {
            _ = exitAction(handler: source)
            return
        }

        // (d) leave from substate(one level)
        if sourceSuper == target {
            _ = exitAction(handler: source)
            path.removeAll()
            return
        }

        // (e) go into substate(multiple level)
        if let targetSuper = targetSuper {
            for tmp in sequence(first: targetSuper, next: { self.getSuperState(handler: $0)?.handler }) {
                if tmp == source {
                    return
                } else {
                    path.append(targetSuper)
                }
            }
        }

        _ = exitAction(handler: source)

        // (f) unbalanced transition
        if let sourceSuper = sourceSuper, path.contains(sourceSuper) {
            return
        }

        // (g) leave from substate(multiple level)
        if let sourceSuper = sourceSuper {
            for tmp in sequence(first: sourceSuper, next: { self.getSuperState(handler: $0)?.handler }) {
                if path.contains(tmp) {
                    assertionFailure("*** Invalid state transition form detected ***")
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
            var next = invoke(handler: source!, event: event)!
            switch next.type {
            case .deferEvent:
                queue.enqueue(key: source!, event: event)

            case .clearHistory:
                history.clear(key: source!)

            case .deepHistory:
                let target = history.deep(key: next.handler)!
                transition(source: source!, target: target)
                initialize(target: .super_(handler: target))

                for defer_ in sequence(state: queue, next: { $0.dequeue(key: source!) }) {
                    // recursion
                    dispatch(event: defer_)
                }

            case .deepForward:
                let target = history.deep(key: next.handler)!
                transition(source: source!, target: target)
                initialize(target: .super_(handler: target))
                next = .super_(handler: target)

            case .transition:
                transition(source: source!, target: next.handler)
                initialize(target: next)

                for defer_ in sequence(state: queue, next: { $0.dequeue(key: source!) }) {
                    // recursion
                    dispatch(event: defer_)
                }

            case .forward:
                transition(source: source!, target: next.handler)
                initialize(target: next)

            default:
                fatalError("*** Invalid state detected ***")
            }
        }
    }
}
