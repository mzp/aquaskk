//
//  SKKKeyState.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/25.
//

extension SKKKeyState: Equatable {}

extension SKKKeyState: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "<SKKKeyState: \(rawValue)>"
    }
}

extension SKKKeyState: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
