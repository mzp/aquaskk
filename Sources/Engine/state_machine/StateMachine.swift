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

    static func initial(handler: HandlerProtocol) -> GenericState {
        .init(type: .initial)
    }
}

// MARK: - State history
struct GenericStateHistory {
    func clear(key: HandlerProtocol){}
}

// MARK: - Deferred event
struct GenericDeferEvent {
    func enqueue(handler: HandlerProtocol, event: GenericEvent) {}
}

// MARK: - Empty Inspector
struct EmptyInspector {}

// MARK: - State Machine
protocol HandlerProtocol {
}
struct StubHandler: HandlerProtocol {}
struct GenericStateMachine<Handler: HandlerProtocol> {
    // &StateContainer::TopState
    var top: HandlerProtocol = StubHandler()
    var active: HandlerProtocol?

    var queue = GenericDeferEvent()
    var history = GenericStateHistory()
    public func start() {
        assert(active == nil, "*** You can not call Start() twice ***")
        initialize(target: GenericState.initial(handler: top))
    }

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

    func exitAction(handler: HandlerProtocol) -> GenericState? {
        let result = invoke(handler: handler, event: .exit)
        /*
         if(result.IsSaveHistory()) {
             assert(prior_ != 0 && "*** Shallow history not found ***");
             history_.Save(handler, prior_, active_);
         }

         queue_.Commit(handler);

         prior_ = handler;
         */
        return result
    }

    // MARK: - initial transition trigger
    func initialize(target: GenericState) {

    }

    var selfTransitionCount = 0
    mutating public func dispatch(event: GenericEvent) {
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
            case .transition, .deepHistory, .forward, .deepForward:
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
                break
            default:
                fatalError("*** Invalid state detected ***")
            }
        }
    }
}

// MARK: - Base State Container
struct BaseStateContainer {}
