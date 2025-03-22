//
//  SKKDictionaryConfiguration.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/23.
//

import AquaSKKService

public struct SKKDictionaryConfiguration {
    var type: JisyoType
    var location: String

    public init?(from key: SKKDictionaryKey) {
        guard let type = JisyoType(rawValue: Int(key.first)) else {
            return nil
        }
        self.type = type
        location = String(key.second)
    }

    public init?(type: Int, location: String) {
        guard let type = JisyoType(rawValue: type) else {
            return nil
        }
        self.type = type
        self.location = location
    }

    init(type: JisyoType, location: String) {
        self.type = type
        self.location = location
    }
}
