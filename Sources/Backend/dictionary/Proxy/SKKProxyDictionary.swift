//
//  SKKProxyDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/22.
//

import AquaSKKLogging
import Foundation
import Network
import OSLog

public class SKKProxyDictionary: SKKBaseDictionaryProtocol {
    var connect: NWConnection?

    public init() {}
    public func initialize(path: String) async throws {
        connect?.cancel()

        let entry = path.split(separator: ":", maxSplits: 2)
        let host = String(entry[0])
        let port: Int16

        if entry.count > 1 {
            port = Int16(entry[1]) ?? 1178
        } else {
            port = 1178
        }
        let endpoint = NWEndpoint.hostPort(host: .init(host), port: .init(port.description) ?? .any)
        Logger.skkBackend.log("\(#function, privacy: .public) endpoint=\(endpoint.debugDescription, privacy: .private)")
        let connect = NWConnection(host: .init(host), port: .init(port.description) ?? .any, using: .tcp)
        connect.stateUpdateHandler = { state in
            switch state {
            case .ready:
                Logger.skkBackend.log("\(#function, privacy: .public) .ready")
            case .cancelled:
                Logger.skkBackend.log("\(#function, privacy: .public) .canncelled")
            case let .failed(error):
                Logger.skkUI.log("\(#function, privacy: .public) .failed: \(error.localizedDescription, privacy: .private)")
            case .preparing:
                Logger.skkBackend.log("\(#function, privacy: .public) .preparing")
            case .setup:
                Logger.skkBackend.log("\(#function, privacy: .public) setup")
            case let .waiting(error):
                Logger.skkUI.log("\(#function, privacy: .public) .waiting: \(error.localizedDescription, privacy: .private)")
            @unknown default:
                ()
            }
        }
        connect.start(queue: .main)
        // remote_.parse(location, "1178");
        //
        // session_.close();
        //
    }

    public func find(entry _: SKKEntry, to _: inout SKKCandidateSuite) {
        guard let connect = connect else {
            return
        }
    }

    public func complete(helper _: inout any SKKCompletionHelperProtocol) {}

    public func reverseLookup(candidate _: String) -> String {
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
