//
//  SKKLocalDictionaryFileSource.swift
//  AquaSKK
//
//  Created by mzp on 2/21/25.
//

import AquaSKKLogging
import OSLog

class SKKLocalDictionaryFileSource: SKKDictionarySourceFileProtocol {
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

    func refresh() async {
        // DO NOTHING
    }
}
