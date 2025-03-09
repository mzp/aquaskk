//
//  GenericDeferEventQueue.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

// MARK: - Deferred event

struct GenericDeferEventQueue<Handler: HandlerProtocol> {
    func enqueue(handler _: Handler, event _: GenericEvent) {}
    func dequeeue(key _: Handler) -> GenericEvent? { nil }

    func commit(key _: Handler) {}
}
