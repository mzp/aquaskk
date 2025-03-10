//
//  GenericDeferEventQueue.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

// MARK: - Deferred event

struct GenericDeferEventQueue<Handler: HandlerProtocol> {
    struct Entry {
        var key: Handler
        var queue: [GenericEvent]
    }

    var incomming: [Entry] = []
    var outgoing: [Entry] = []

    mutating func enqueue(key: Handler, event: GenericEvent) {
        if let index = incomming.firstIndex(where: { $0.key == key }) {
            incomming[index].queue.append(event)
        } else {
            incomming.insert(.init(key: key, queue: [event]), at: 0)
        }
    }

    mutating func dequeue(key: Handler) -> GenericEvent? {
        guard let index = outgoing.firstIndex(where: { $0.key == key }) else {
            return nil
        }
        if outgoing[index].queue.isEmpty {
            return nil
        }
        return outgoing[index].queue.removeFirst()
    }

    mutating func commit(key: Handler) {
        if let index = incomming.firstIndex(where: { $0.key == key }) {
            outgoing.insert(incomming[index], at: 0)
            incomming.remove(at: index)
        }
    }
}
