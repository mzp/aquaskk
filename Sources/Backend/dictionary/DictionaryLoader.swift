//
//  DictionaryLoader.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/30/24.
//

import Foundation
import OSLog

protocol DictionaryLoaderDelegate: AnyObject {
    func dictionaryLoaderDidUpdate(file: DictionaryFile)
}

class DictionaryLoader {
    private var first = true
    weak var delegate: DictionaryLoaderDelegate?
    private var file = DictionaryFile()

    func run() {
        if first {
            first = false
            notify()
        }
        if needsUpdate() {
            notify()
        } else {
            // 不要な pthread_cond_wait を回避するため、空のファイルを通知する
            if file.isEmpty {
                delegate?.dictionaryLoaderDidUpdate(file: file)
            }
        }
    }

    private func notify() {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            defer { semaphore.signal() }
            do {
                try await file.load(path: filePath())
                file.sort()
                delegate?.dictionaryLoaderDidUpdate(file: file)
            } catch {
                Logger.backend.error("Can't load file due to \(error)")
            }
        }
        semaphore.wait()
    }

    // MARK: - Overrides

    func needsUpdate() -> Bool {
        false
    }

    func filePath() -> String {
        ""
    }

    func interval() -> TimeInterval {
        return 0
    }

    func timeout() -> TimeInterval {
        return 0
    }
}
