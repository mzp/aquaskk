//
//  GenericStateHistory.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

// MARK: - State history

struct GenericStateHistory {
    struct Entry {
        var key: HandlerProtocol
        var shallow: HandlerProtocol?
        var deep: HandlerProtocol?
    }

    var history: [Entry]

    init() {
        history = []
    }

    mutating func save(key: HandlerProtocol, shallow: HandlerProtocol?, deep: HandlerProtocol?) {
        if var entry = history.first(where: { $0.key.handlerID == key.handlerID }) {
            entry.shallow = shallow
            entry.deep = deep
        } else {
            history.insert(.init(key: key, shallow: shallow, deep: deep), at: 0)
        }
    }

    mutating func clear(key: HandlerProtocol) {
        history.removeAll(where: { $0.key.handlerID == key.handlerID })
    }

    func shallow(key: HandlerProtocol) -> HandlerProtocol? {
        history.first(where: { $0.key.handlerID == key.handlerID })?.shallow
    }

    func deep(key: HandlerProtocol) -> HandlerProtocol? {
        history.first(where: { $0.key.handlerID == key.handlerID })?.deep
    }
}
