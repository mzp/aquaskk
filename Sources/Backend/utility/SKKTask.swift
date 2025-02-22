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
    static func perfromAndWait(run: @escaping () async -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            defer { semaphore.signal() }
            await run()
        }
        semaphore.wait()
    }
}
