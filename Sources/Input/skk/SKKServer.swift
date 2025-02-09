//
//  SKKServer.swift
//  AquaSKKInput
//
//  Created by mzp on 2/8/25.
//

import OSLog
import AquaSKKService
import AquaSKKCore
import Foundation

func terminate(_ signal: Int32) {
    Task {
        await MainActor.run {
            NSApp.terminate(nil)
        }
    }

}

public class SKKServer2: NSObject {
    private var imkServer: IMKServer? = nil
    private var configuration: ServerConfiguration? = nil
    private var userDefaults : AISUserDefaults? = nil
    private var skkserv: skkserv? = nil
    private var connection: NSXPCConnection? = nil

    public override func awakeFromNib() {
        start()
        imkServer = newIMKServer()
    }

    @_spi(Testing) public func start() {
        start(with: DefaultServerConfiguration())
    }

    @_spi(Testing) public func start(with configuration: ServerConfiguration) {
        self.configuration = configuration
        self.userDefaults = .init(serverConfiguration: configuration)
        self.skkserv = nil
    }

    func newIMKServer() -> IMKServer {
        let bundle = Bundle.main
        let connection = bundle.infoDictionary?["InputMethodConnectionName"] as? String
        if connection == nil {
            Logger.skkInput.warning("\(#function, privacy: .public) InputMethodConnectionName not found in Info.plist")
        }
        let identifier = bundle.bundleIdentifier
        if identifier == nil {
            Logger.skkInput.warning("\(#function, privacy: .public) bundle.bundleIdentifier is nil")
        }
        return IMKServer(name: connection ?? "", bundleIdentifier: identifier)
    }

    // MARK: - Preparation

    func prepareSignalHandler() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        signal(SIGHUP, terminate)
        signal(SIGINT, terminate)
        signal(SIGTERM, terminate)
        signal(SIGPIPE, SIG_IGN)
    }

    func prepareDirectory() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        let path = SKKFilePaths.ApplicationSupportFolder

        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: true)
            } catch let error {
                Logger.skkInput.error("\(#function, privacy: .public) create directory[\(path, privacy: .private)] failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    func prepareConnection() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        // TODO: Migrate from NSConnection
        let interface = NSXPCInterface(with: SKKSupervisor.self)
        let connection = NSXPCConnection(machServiceName: "SKKSupervisorConnection")
        connection.remoteObjectInterface = interface
        connection.exportedInterface = interface
        connection.exportedObject = self
        connection.resume()

        self.connection = connection
    }

    func prepareUserDefaults() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        userDefaults?.prepare()
    }

    func prepareDictionarySet() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        guard let factoryDictionarySet = configuration?.systemPath(forName: "DictionarySet.plist") else {
            Logger.skkInput.error("\(#function, privacy: .public) failed to get system path for DictionarySet.plist (fallback)")
            return
        }
        let userDictionarySet = SKKFilePaths.DictionarySet

        do {
            if !FileManager.default.fileExists(atPath: userDictionarySet) {
                Logger.skkInput.warning("\(#function, privacy: .public) \(userDictionarySet, privacy: .public) doesn't exist. Copy from \(factoryDictionarySet)")
                try FileManager.default.copyItem(atPath: factoryDictionarySet, toPath: userDictionarySet)
            }
        } catch let error {
            Logger.skkInput.error("\(#function, privacy: .public) \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Supervisor

    public func reloadBlacklistApps() {

    }
    
    public func reloadUserDefaults() {

    }
    
    public func reloadDictionarySet() {

    }
    
    public func reloadComponents() {

    }
    
    public func createDictionaryTypes() -> [[AnyHashable : Any]]! {
        return []
    }
}
