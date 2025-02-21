//
//  SKKDictionarySourceProtocol.swift
//  AquaSKK
//
//  Created by mzp on 2/21/25.
//

protocol SKKDictionarySourceProtocol {
    var path: String? { get }
        func initialize(location: String)
        var interval: TimeInterval { get }
        var timeout: TimeInterval { get }
        var needsUpdate: Bool { get }
}
