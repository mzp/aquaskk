//
//  SKKProxyDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/22.
//

import Foundation
import AquaSKKLogging
import OSLog

public class SKKProxyDictionary: SKKBaseDictionaryProtocol {
    public init() {}
    public func initialize(path: String) async throws {
/*
 remote_.parse(location, "1178");

 session_.close();

 */
    }
    
    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {

    }
    
    public func complete(helper: inout any SKKCompletionHelperProtocol) {

    }
    
    public func reverseLookup(candidate: String) -> String {
        return ""
    }

    // MARK: - C++ Bridge
    public func initialize(path: String) {
        SKKTask.perfromAndWait {
            do {
                try await self.initialize(path: path)
            } catch {
                Logger.backend.error("\(#function, privacy: .public) can't load file: \(path, privacy: .private) due to \(error)")
            }
        }
    }

}
