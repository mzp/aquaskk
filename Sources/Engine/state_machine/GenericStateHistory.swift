//
//  GenericStateHistory.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

// MARK: - State history

struct GenericStateHistory<Handler: HandlerProtocol> {
    struct Entry {
        var key: Handler
        var shallow: Handler?
        var deep: Handler?
    }
    var history: [Entry]

    init() {
        history = []
    }

    mutating func save(key: Handler, shallow: Handler?, deep: Handler?) {
        if var entry = history.first(where: { $0.key == key }) {
            entry.shallow = shallow
            entry.deep = deep
        } else {
            history.insert(.init(key: key, shallow: shallow, deep: deep), at: 0)
        }
    }
    mutating func clear(key: Handler) {
        history.removeAll(where: { $0.key == key })
    }
    func shallow(key: Handler) -> Handler? {
        history.first(where: { $0.key == key })?.shallow
    }

    func deep(key: Handler) -> Handler? {
        history.first(where: { $0.key == key })?.deep
    }
}
