//
//  SKKProxyDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/22.
//

import AquaSKKLogging
import Network
import OSLog

public class SKKProxyDictionary: SKKBaseDictionaryProtocol {
    static let queue = DispatchQueue(label: "SKKProxyDictionary")
    private var connect: NWConnection?

    public init() {}

    public func initialize(path: String) async throws {
        let entry = path.split(separator: ":", maxSplits: 2)
        let host = String(entry[0])
        let port: Int
        if entry.count > 1 {
            port = Int(entry[1]) ?? 1178
        } else {
            port = 1178
        }
        try await initialize(host: host, port: port)
    }

    public func initialize(host: String, port: Int) async throws {
        connect?.cancel()
        let connect = NWConnection(host: .init(host), port: .init(port.description) ?? .any, using: .tcp)
        connect.stateUpdateHandler = { state in
            switch state {
            case .ready:
                Logger.skkBackend.log("\(#function, privacy: .public) .ready")

            case .cancelled:
                Logger.skkBackend.log("\(#function, privacy: .public) .canncelled")

            case let .failed(error):
                Logger.skkBackend.log("\(#function, privacy: .public) .failed: \(error.localizedDescription, privacy: .private)")

            case .preparing:
                Logger.skkBackend.log("\(#function, privacy: .public) .preparing")

            case .setup:
                Logger.skkBackend.log("\(#function, privacy: .public) setup")

            case let .waiting(error):
                Logger.skkBackend.error("[\(#fileID, privacy: .public):\(#function, privacy: .public)] .waiting: \(error.localizedDescription, privacy: .private)")
                self.connect?.cancel()
                self.connect = nil

            @unknown default:
                ()
            }
        }
        connect.start(queue: Self.queue)
        self.connect = connect
    }

    deinit {
        connect?.cancel()
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        let suite = SKKTask.perfromAndWait(timeout: .now().advanced(by: .seconds(1))) {
            await self.find(entry: entry)
        }
        if let suite = suite {
            result.add(suite: suite)
        }
    }

    public func find(entry: SKKEntry) async -> SKKCandidateSuite? {
        var data = Data()
        if let lookup = "1".data(using: .utf8) {
            data.append(lookup)
        }
        let entryString = SKKRawArray(SKKEncoding.eucj_from_utf8(entry.EntryString()))
        data.append(contentsOf: entryString)
        if let term = " ".data(using: .utf8) {
            data.append(term)
        }
        Logger.skkBackend.debug("\(#function, privacy: .public) Looking up:\(entry.EntryString())")

        guard let response = await send(data: data),
              let content = String(data: response, encoding: .japaneseEUC),
              content.first != "0"
        else {
            Logger.skkBackend.error("[\(#fileID, privacy: .public):\(#function, privacy: .public)]Can't send request to the server.")
            return nil
        }
        let string = String(content.dropFirst())
        return SKKCandidateSuite(string: string)
    }

    func send(data: Data) async -> Data? {
        guard let connect = connect else {
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
                continuation.resume(returning: content)
            }
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

    @_spi(Testing) public func queryClose() async {
        _ = await query(command: "0")
    }

    @_spi(Testing) public func queryVersion() async -> String? {
        await query(command: "2")
    }

    @_spi(Testing) public func queryHost() async -> String? {
        await query(command: "3")
    }

    @discardableResult @_spi(Testing) public func query(command: String) async -> String? {
        guard let request = command.data(using: .utf8),
              let response = await send(data: request)
        else {
            Logger.skkBackend.error("[\(#fileID, privacy: .public):\(#function, privacy: .public)] Can't send request to the server.")
            return nil
        }
        return String(data: response, encoding: .utf8)
    }
}
