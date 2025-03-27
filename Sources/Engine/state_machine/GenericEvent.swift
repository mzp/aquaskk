//
//  GenericEvent.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

struct GenericEvent {
    var signal: SKKEventID

    static let exit: GenericEvent = .init(signal: SKKEventID.exitEvent)
    static let init_: GenericEvent = .init(signal: .initEvent)
    static let entry: GenericEvent = .init(signal: .entryEvent)
    static let probe: GenericEvent = .init(signal: .probeEvent)
}
