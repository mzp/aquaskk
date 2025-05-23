//
//  skkserv.swift
//  AquaSKKServer
//
//  Created by mzp on 2025/05/23.
//

import AquaSKKBackend
import Foundation

public final class SKKServ: Sendable {
    public static func find(entry: String, okuri: String) -> String {
        SKKBackendImpl.shared().bridgeFind(entry: SKKEntry(std.string(entry), std.string(okuri)))
    }
}
