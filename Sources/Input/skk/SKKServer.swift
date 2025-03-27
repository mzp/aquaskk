//
//  SKKServer.swift
//  AquaSKKInput
//
//  Created by mzp on 2/8/25.
//

import AquaSKKBackend
import AquaSKKEngine
import AquaSKKServer
import AquaSKKService
import AquaSKKUI
import InputMethodKit
import OSLog

func terminate(_: Int32) {
    Task {
        await MainActor.run {
            NSApp.terminate(nil)
        }
    }
}

@objc(SKKServer) public class SKKServer: NSObject, SKKSupervisor {
    private var imkServer: IMKServer? = nil
    private var configuration: ServerConfiguration? = nil
    private var userDefaults: AISUserDefaults? = nil
    private var skkserv: skkserv? = nil

    deinit {
        skkserv?.close()
        skkserv = nil
    }

    override public func awakeFromNib() {
        _start()
        imkServer = newIMKServer()
    }

    @_spi(Testing) public func _start() {
        _start(with: DefaultServerConfiguration())
    }

    @_spi(Testing) public func _start(with configuration: ServerConfiguration) {
        self.configuration = configuration
        userDefaults = .init(serverConfiguration: configuration)
        skkserv?.close()
        skkserv = nil

        prepareSignalHandler()
        prepareDirectory()
        prepareConnection()
        prepareUserDefaults()
        prepareDictionarySet()
        prepareDictionary()
        prepareBlacklistApps()

        reloadBlacklistApps()
        reloadDictionarySet()
        reloadUserDefaults()
        reloadComponents()
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

    private func prepareSignalHandler() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        signal(SIGHUP, terminate)
        signal(SIGINT, terminate)
        signal(SIGTERM, terminate)
        signal(SIGPIPE, SIG_IGN)
    }

    private func prepareDirectory() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        let path = SKKFilePaths.ApplicationSupportFolder

        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: true)
            } catch {
                Logger.skkInput.error("\(#function, privacy: .public) create directory[\(path, privacy: .private)] failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    private func prepareConnection() {
        Logger.skkInput.log("[\(#fileID, privacy: .public)\(#function, privacy: .public)]")

        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(reloadBlacklistApps), name: .skkSupervisorReloadBlacklistApps, object: nil)
        center.addObserver(self, selector: #selector(reloadUserDefaults), name: .skkSupervisorReloadUserDefaults, object: nil)
        center.addObserver(self, selector: #selector(reloadDictionarySet), name: .skkSupervisorReloadDictionarySets, object: nil)
        center.addObserver(self, selector: #selector(reloadComponents), name: .skkSupervisorReloadComponents, object: nil)
    }

    private func prepareUserDefaults() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        userDefaults?.prepare()
    }

    private func prepareDictionarySet() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        guard let templatePath = configuration?.systemPath(forName: "DictionarySet.plist") else {
            Logger.skkInput.error("\(#function, privacy: .public) failed to get system path")
            return
        }
        let path = SKKFilePaths.DictionarySet

        do {
            let fm = FileManager.default
            if !fm.fileExists(atPath: path) {
                Logger.skkInput.warning("\(#function, privacy: .public) \(path, privacy: .public) doesn't exist. Copy from \(templatePath)")
                try FileManager.default.copyItem(atPath: templatePath, toPath: path)
            }
        } catch {
            Logger.skkInput.error("\(#function, privacy: .public) \(error.localizedDescription, privacy: .public)")
        }
    }

    private func prepareDictionary() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        guard let configuration = configuration else {
            return
        }
        let fm = FileManager.default
        for jisyo in configuration.systemDictionaries() {
            guard let location = jisyo[SKKDictionarySetKeys.location] as? String
            else {
                Logger
                    .skkInput.error("unexpected dictionary format: \(jisyo, privacy: .public)")
                continue
            }

            let path = configuration.systemPath(forName: location)
            guard fm.fileExists(atPath: path) else {
                Logger.skkInput.error("\(#function, privacy: .public) can't find \(path, privacy: .public); Skipping.")
                continue
            }
            let filename = (path as NSString).lastPathComponent
            let userPath = configuration.userPath(forName: filename)
            if fm.fileExists(atPath: userPath) {
                Logger.skkInput.log("\(#function, privacy: .public) \(userPath, privacy: .public) already exists. Skipping.")
                continue
            }

            do {
                try fm.copyItem(atPath: path, toPath: userPath)
                Logger.skkInput.log("\(#function, privacy: .public) copied \(path, privacy: .public) to \(userPath, privacy: .public)")
            } catch {
                Logger.skkInput.error("\(#function, privacy: .public) can't copy \(path, privacy: .public) to \(userPath, privacy: .public) due to \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    private func prepareBlacklistApps() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        guard let templatePath = configuration?.systemPath(forName: "BlacklistApps.plist") else {
            Logger.skkInput.error("\(#function, privacy: .public) failed to get system path")
            return
        }
        let path = SKKFilePaths.DictionarySet

        do {
            let fm = FileManager.default
            if !fm.fileExists(atPath: path) {
                Logger.skkInput.warning("\(#function, privacy: .public) \(path, privacy: .public) doesn't exist. Copy from \(templatePath)")
                try FileManager.default.copyItem(atPath: templatePath, toPath: path)
            }
        } catch {
            Logger.skkInput.error("\(#function, privacy: .public) \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Supervisor

    public func reloadBlacklistApps() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        guard let array = NSArray(contentsOfFile: SKKFilePaths.BlacklistApps) else {
            Logger.skkInput.error("\(#function, privacy: .public) can't read BlacklistApps.plist")
            return
        }
        guard let entries = array as? [BlacklistApps.AppEntry] else {
            Logger.skkInput.error("\(#function, privacy: .public) BlacklistApps.plist has incorrect data format")
            return
        }
        BlacklistApps.shared().load(entries)
    }

    public func reloadUserDefaults() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        skkserv?.close()
        skkserv = nil

        userDefaults?.reload()
        guard let defaults = userDefaults?.standard else {
            return
        }

        if defaults.bool(forKey: SKKUserDefaultKeys.enable_skkserv) {
            let port = defaults.integer(forKey: SKKUserDefaultKeys.skkserv_port)
            let isLocalOnly = defaults.bool(forKey: SKKUserDefaultKeys.skkserv_localonly)
            skkserv = .init(UInt16(port), isLocalOnly)
            Logger.skkInput.log("[\(#fileID, privacy: .public)\(#function, privacy: .public)]Launch SKKServ at \(isLocalOnly ? "127.0.0.1" : "0.0.0.0"):\(port, privacy: .private)")
        } else {
            Logger.skkInput.log("[\(#fileID, privacy: .public)\(#function, privacy: .public)]SKKServ is disabled")
        }
        let backend = SKKBackendImpl.shared()

        let numericConversion = defaults.bool(forKey: SKKUserDefaultKeys.use_numeric_conversion)
        backend.numericConversionEnabled = numericConversion

        let extendedCompletion = defaults.bool(forKey: SKKUserDefaultKeys.enable_extended_completion)
        backend.extendedCompletionEnabled = extendedCompletion

        let privateModeEnabled = defaults.bool(forKey: SKKUserDefaultKeys.enable_private_mode)
        backend.privateModeEnabled = privateModeEnabled

        let length = defaults.integer(forKey: SKKUserDefaultKeys.minimum_completion_length)
        backend.minimumCompletionLength = length
    }

    public func reloadDictionarySet() {
        Logger.skkInput.log("\(#function, privacy: .public)")

        guard let configuration = configuration else {
            return
        }
        guard let defaults = userDefaults?.standard else {
            return
        }

        var keys = [SKKDictionaryConfiguration]()
        for entry in configuration.systemDictionaries() {
            let active = entry[SKKDictionarySetKeys.active]
            if (active as? Bool) == true {
                guard let type = entry[SKKDictionarySetKeys.type] as? Int else {
                    continue
                }
                let location: String
                if let value = entry[SKKDictionarySetKeys.location] as? String, !value.isEmpty {
                    if type == JisyoType.autoUpdate.rawValue {
                        guard let host = defaults.string(forKey: SKKUserDefaultKeys.openlab_host) else {
                            Logger.skkInput.error("\(#function, privacy: .public): No openlab host")
                            continue
                        }
                        guard let path = defaults.string(forKey: SKKUserDefaultKeys.openlab_path) else {
                            Logger.skkInput.error("\(#function, privacy: .public): No openlab path")
                            continue
                        }
                        let basename = (value as NSString).lastPathComponent
                        let localPath = configuration.path(forName: basename)

                        location = "\(host) \(path)/\(basename) \(localPath)"
                    } else {
                        location = (value as NSString).expandingTildeInPath
                    }
                } else {
                    location = "[location was not specified]"
                }

                if let config = SKKDictionaryConfiguration(type: type, location: location) {
                    Logger.skkInput.log("\(#function, privacy: .public) loading \(type) from \(location, privacy: .private)")
                    keys.append(config)
                }
            }
        }
        SKKTask.perfromAndWait {
            await SKKBackendImpl.shared().initialize(path: configuration.userDictionaryPath, configurations: keys)
        }
    }

    public func reloadComponents() {
        Logger.skkInput.log("\(#function, privacy: .public)")

        guard let configuration = configuration else {
            return
        }
        guard let defaults = userDefaults?.standard else {
            return
        }

        let keymap = configuration.path(forName: "keymap.conf")
        let subKeymaps = defaults.array(forKey: SKKUserDefaultKeys.sub_keymaps) as? [String]

        let kanaRule = configuration.path(forName: "kana-rule.conf")
        let subRules = defaults.array(forKey: SKKUserDefaultKeys.sub_rules) as? [String]

        Logger.skkInput.log("\(#function, privacy: .public) loading keymap: \(keymap, privacy: .public)")
        SKKPreProcessor.shared().initialize(path: keymap)

        for subKeymap in subKeymaps ?? [] {
            Logger.skkInput.log("\(#function, privacy: .public) loading custom keymap: \(subKeymap, privacy: .public)")
            SKKPreProcessor.shared().patch(path: subKeymap)
        }

        RomanKanaConverterImpl.shared().initialize(from: kanaRule)

        for subRule in subRules ?? [] {
            Logger.skkInput.log("\(#function, privacy: .public) loading custom kana rule: \(subRule, privacy: .public)")
            RomanKanaConverterImpl.shared().patch(from: subRule)
        }

        initializeInputModeIcons()
    }

    private func initializeInputModeIcons() {
        let modes: [SKKInputMode: NSImage] = [
            .HirakanaInputMode: NSImage(named: "AquaSKK-Hirakana")!,
            .KatakanaInputMode: NSImage(named: "AquaSKK-Katakana")!,
            .Jisx0201KanaInputMode: NSImage(named: "AquaSKK-Jisx0201Kana")!,
            .AsciiInputMode: NSImage(named: "AquaSKK-Ascii")!,
            .Jisx0208LatinInputMode: NSImage(named: "AquaSKK-Jisx0208Latin")!,
        ]
        InputModeWindow.shared().setModeIcons(modes as NSDictionary)
    }

    public func createDictionaryTypes() -> [[AnyHashable: Any]]! {
        Logger.skkInput.log("\(#function, privacy: .public)")
        return Jisyo.dictionaryTypes()
    }
}
