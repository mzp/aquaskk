//
//  StateMachine.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/08.
//

// MARK: - Event types
enum EventType {
    case exit
    case init_
    case entry
    case probe
    case user
}

// MARK: - Event

struct GenericEvent {
    var signal: EventType

    static let exit: GenericEvent = .init(signal: .exit)
    static let init_: GenericEvent = .init(signal: .init_)
    static let entry: GenericEvent = .init(signal: .entry)
    static let probe: GenericEvent = .init(signal: .probe)

}

// MARK: - State

enum StateType {
    case unknown
    case super_
    case initial
    case transition
    case saveHistory
    case shalllowHistory
    case deepHistory
    case forward
    case deepForward
    case deferEvent
    case clearHistory
};

struct GenericState {
    var type: StateType
    var handler: HandlerProtocol

    init(type: StateType, handler: HandlerProtocol) {
        self.type = type
        self.handler = handler
    }

    static func initial(handler: HandlerProtocol) -> GenericState {
        .init(type: .initial, handler: handler)
    }

    static func super_(handler: HandlerProtocol) -> GenericState {
        .init(type: .super_, handler: handler)
    }
}

// MARK: - State history
struct GenericStateHistory {
    func save(key: HandlerProtocol, shallow: HandlerProtocol?, deep: HandlerProtocol?) {}
    func clear(key: HandlerProtocol){}
    func shallow(key: HandlerProtocol) -> HandlerProtocol? {
        fatalError()
    }
    func deep(key: HandlerProtocol) -> HandlerProtocol? {
        fatalError()
    }
}

// MARK: - Deferred event
struct GenericDeferEvent {
    func enqueue(handler: HandlerProtocol, event: GenericEvent) {}
    func dequeeue(key: HandlerProtocol) -> GenericEvent? { nil }

        func commit(key: HandlerProtocol){}
}

// MARK: - Empty Inspector
struct EmptyInspector {}

// MARK: - State Machine
protocol HandlerProtocol {
}
struct StubHandler: HandlerProtocol {}
class GenericStateMachine<Handler: HandlerProtocol> {
    // &StateContainer::TopState
    var top: HandlerProtocol = StubHandler()
    var active: HandlerProtocol?

    var queue = GenericDeferEvent()
    var history = GenericStateHistory()

    // MARK: - invoke state function
    func invoke(handler: HandlerProtocol, event: GenericEvent) -> GenericState? {
        fatalError()
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

    var prior: (any HandlerProtocol)?
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

        for state in sequence(state: active, next: { handler -> GenericState? in
            guard let state = self.initialTransition(handler: handler) else {
                fatalError("*** Initial transition must be ended by returning super state ***")
            }
            switch state.type {
            case .initial, .shalllowHistory:
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

        if source == target {
            exitAction(handler: source)
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
                queue.enqueue(handler: source!, event: event)
                break
            case .clearHistory:
                history.clear(key: source!)
                break
            case .deepHistory:
                let target = history.deep(key: next.handler)!
                transition(source: source!, target: target)
                initialize(target: .super_(handler: target))

                for defer_ in sequence(state: queue, next: { $0.dequeeue(key: source!) }) {
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


                for defer_ in sequence(state: queue, next: { $0.dequeeue(key: source!) }) {
                    // recursion
                    dispatch(event: defer_)
                }

            case .forward:
                transition(source: source!, target: next.handler)
                initialize(target: next)


/*
 State target = next;

 if(next.IsDeepHistory() || next.IsDeepForward()) {
     target = history_.Deep(next);
     assert(target != 0 && "*** Deep history not found ***");
 }

 transition(source, target);
 initialize(target);

 if(next.IsForward() || next.IsDeepForward()) {
     next = target;
     continue;
 }

 while(queue_.Dequeue(source, defer_)) {
     Dispatch(defer_); // recursion
 }
 */
            default:
                fatalError("*** Invalid state detected ***")
            }
        }
    }
}

// MARK: - Base State Container
struct BaseStateContainer {}
