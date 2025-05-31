//
//  SKKDistributedUserDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/22.
//

import AquaSKKLogging
import Network
import OSLog

public class SKKDistributedUserDictionary: SKKBaseDictionaryProtocol, SKKUserDictionaryProtocol {
    static let queue = DispatchQueue(label: "SKKDistributedUserDictionary")
    private var connect: NWConnection?

    public init() {}
    public func initialize(path: String) async throws {
        connect?.cancel()

        let entry = path.split(separator: ":", maxSplits: 2)
        let host = String(entry[0])

        let connect = NWConnection(host: .init(host), port: .init(entry.count > 1 ? String(entry[1]) : "") ?? .any, using: .tcp)

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
        connect.start(queue: Self.queue)
        self.connect = connect
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        let suite = SKKTask.perfromAndWait(timeout: .now().advanced(by: .seconds(1))) {
            await self.find(entry: entry)
        }

        if let suite = suite {
            Logger.skkBackend.info("\(#function, privacy: .public) found: \(suite.string(), privacy: .private)")
            result.add(suite: suite)
        }
    }

    public func find(entry: SKKEntry) async -> SKKCandidateSuite? {
        guard let response = await send(commands: ["GET", String(entry.EntryString()), String(entry.OkuriString())]) else {
            return nil
        }
        return SKKCandidateSuite(string: response)
    }

    public func complete(helper: inout any SKKCompletionHelperProtocol) {
        let entry = helper.entry
        let response = SKKTask.perfromAndWait(timeout: .now().advanced(by: .seconds(1))) {
            let response = await self.send(commands: ["COMPLETE", String(entry)])
            return response?.split(separator: "/") ?? []
        }

        for candidate in response ?? [] {
            guard helper.canContinue else {
                return
            }
            helper.add(completion: String(candidate))
        }
    }

    public func reverseLookup(candidate _: String) -> String {
        // サポートしない
        return ""
    }

    public func register(entry: SKKEntry, candidate: SKKCandidate) -> Bool {
        var tmp = candidate
        tmp.Encode()
        let response = SKKTask.perfromAndWait(timeout: .now().advanced(by: .seconds(1))) {
            _ = await self.send(commands: ["PUT", String(entry.EntryString()), String(tmp.ToString()), String(entry.OkuriString())])
            return true
        }
        return response ?? false
    }

    public func remove(entry: SKKEntry, candidate: SKKCandidate) {
        var tmp = candidate
        tmp.Encode()
        _ = SKKTask.perfromAndWait(timeout: .now().advanced(by: .seconds(1))) {
            _ = await self.send(commands: ["DELETE", String(entry.EntryString()), String(tmp.ToString()), String(entry.OkuriString())])
            return true
        }
    }

    public func setPrivateMode(value _: Bool) {}

    // MARK: - Network

    func send(commands: [String]) async -> String? {
        guard let connect = connect else {
            return nil
        }
        guard let data = (commands.joined(separator: "\t") + "\r\n").data(using: .utf8) else {
            return nil
        }
        return await withCheckedContinuation { continuation in
            connect.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    Logger.skkBackend.error("\(#function, privacy: .public) error=\(error.localizedDescription, privacy: .private)")
                }
            })
            connect.receive(minimumIncompleteLength: 2, maximumLength: 1024 * 1024) { content, _, _, error in
                if let error = error {
                    Logger.skkBackend.error("\(#function, privacy: .public) error=\(error.localizedDescription, privacy: .private)")
                }
                if let content = content,
                   let string = String(data: content, encoding: .utf8)
                {
                    let lines = string.split(separator: "\r\n", maxSplits: 2)
                    if lines.first == "OK", lines.count > 1 {
                        continuation.resume(returning: String(lines[1]))
                    } else {
                        continuation.resume(returning: "")
                    }
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
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

    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: SKKCompletionHelperProtocol = helper
        complete(helper: &tmp)
    }
}
