//
//  SKKDictionarySourceFileProtocol.swift
//  AquaSKK
//
//  Created by mzp on 2/21/25.
//

protocol SKKDictionarySourceFileProtocol {
    var path: String? { get }
    func initialize(location: String)
    var interval: TimeInterval { get }
    var timeout: TimeInterval { get }
    func refresh() async throws
}
