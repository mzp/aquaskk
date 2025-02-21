//
//  SKKDictionaryLocalSource.swift
//  AquaSKK
//
//  Created by mzp on 2/21/25.
//

import OSLog
import AquaSKKLogging

class SKKDictionaryLocalSource: SKKDictionarySourceProtocol {
    var path: String?

    func initialize(location: String) {
        path = location
    }

    var interval: TimeInterval {
        60.0
    }
    var timeout: TimeInterval {
        1.0
    }

    var date: Date?

    var needsUpdate: Bool {
        guard let path = path else {
            return false
        }
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            guard let date = attributes[FileAttributeKey.modificationDate] as? Date else {
                return true
            }
            let needsUpdate: Bool
            if let prevDate = self.date {
                needsUpdate = date > prevDate
            } else {
                needsUpdate = true
            }
            self.date = date
            return needsUpdate
        } catch let error {
            Logger.skkBackend.error("\(#function, privacy: .public) \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
}
