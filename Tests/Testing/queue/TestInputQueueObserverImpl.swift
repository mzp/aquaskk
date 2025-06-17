//
//  TestInputQueueObserverImpl.swift
//  AquaSKK
//
//  Created by mzp on 2025/05/31.
//

import AquaSKKEngine
import Foundation

public class TestInputQueueObserverImpl: SKKInputQueueObserverProtocol {
    var fixed: String = ""
    var queue: String = ""

    public init() {}

    public func bridgeInputQueueUpdate(fixed: String, intermediate _: String, queue: String, code _: Int) {
        self.fixed += fixed
        self.queue = queue
    }

    public func clear() {
        fixed = ""
        queue = ""
    }

    public func isEqual(fixed: String, queue: String) -> Bool {
        return self.fixed == fixed && self.queue == queue
    }

    public func getDescription() -> String {
        "(fixed=\(fixed), queue=\(queue))"
    }

    public func getInputQueueObserverProtocol() -> SKKInputQueueObserverProtocol {
        return self
    }
}
