//
//  GenericDeferEventQueue.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

// MARK: - Deferred event

struct GenericDeferEventQueue {
    struct Entry {
        var key: HandlerProtocol
        var queue: [GenericEvent]
    }

    var incomming: [Entry] = []
    var outgoing: [Entry] = []

    mutating func enqueue(key: HandlerProtocol, event: GenericEvent) {
        if let index = incomming.firstIndex(where: { $0.key.handlerID == key.handlerID }) {
            incomming[index].queue.append(event)
        } else {
            incomming.insert(.init(key: key, queue: [event]), at: 0)
        }
    }

    mutating func dequeue(key: HandlerProtocol) -> GenericEvent? {
        guard let index = outgoing.firstIndex(where: { $0.key.handlerID == key.handlerID }) else {
            return nil
        }
        if outgoing[index].queue.isEmpty {
            return nil
        }
        return outgoing[index].queue.removeFirst()
    }

    mutating func commit(key: HandlerProtocol) {
        if let index = incomming.firstIndex(where: { $0.key.handlerID == key.handlerID }) {
            outgoing.insert(incomming[index], at: 0)
            incomming.remove(at: index)
        }
    }
}
