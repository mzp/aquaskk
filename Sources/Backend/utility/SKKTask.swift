//
//  SKKTask.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import AquaSKKLogging
import Foundation
import OSLog

enum SKKTask {
    static func perfromAndWait<T>(timeout: DispatchTime = .distantFuture, run: @escaping () async -> T?) -> T? {
        var value: T?
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            defer { semaphore.signal() }
            value = await run()
        }
        _ = semaphore.wait(timeout: timeout)
        return value
    }
}
