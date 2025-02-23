//
//  SKKDictionaryConfiguration.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/23.
//

import AquaSKKService

struct SKKDictionaryConfiguration {
    var type: JisyoType
    var location: String

    init?(from key: SKKDictionaryKey) {
        guard let type = JisyoType(rawValue: Int(key.first)) else {
            return nil
        }
        self.type = type
        location = String(key.second)
    }

    init(type: JisyoType, location: String) {
        self.type = type
        self.location = location
    }
}
