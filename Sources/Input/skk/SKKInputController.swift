//
//  SKKInputController.swift
//  AquaSKKInput
//
//  Created by mzp on 2/12/25.
//

import AquaSKKEngine
import AquaSKKService
import InputMethodKit
import OSLog

public class SKKInputController: IMKInputController {
    private var client: IMKTextInput?
    private var context: NSTextInputContext?
    private var activated: Bool = false
    private var proxy: SKKServerProxy?
    private var skkMenu: SKKInputMenu?
    private var layoutManager: SKKLayoutManager?
    private var modeIcon: MacInputModeWindow?
    private var inputModeMenu: MacInputModeMenu?
    private var blacklistApps: BlacklistApps?
    private var preProcessor: SKKPreProcessor?
    private var session: SKKInputSessionBridge?

    override public init() {
        super.init()
    }

    override public init!(server: IMKServer!, delegate: Any!, client inputClient: Any!) {
        super.init(server: server, delegate: delegate, client: inputClient)
    }

    @_spi(Testing)
    public func skkInputMenu() -> SKKInputMenu? {
        return skkMenu
    }

    @_spi(Testing)
    public func _setClient(_ client: IMKTextInput, sessionParameter: OpaquePointer) {
        let session = SKKInputSessionBridge(parameter: sessionParameter)
        setClient(client, session: session)
    }

    @_spi(Testing) @objc(_setClient:)
    public func _setClient(_ client: Any) {
        guard let client = client as? IMKTextInput else {
            return
        }
        setClient(client, session: nil)
    }

    private func setClient(_ client: Any, session: SKKInputSessionBridge?) {
        if let client = client as? NSTextInputClient {
            context = NSTextInputContext(client: client)
        } else {
            context = nil
        }
        activated = false
        proxy = SKKServerProxy()
        if let client = client as? IMKTextInput {
            let skkMenu = SKKInputMenu(with: client)

            let layoutManager = SKKLayoutManager(client: client)
            self.client = client
            self.session = session ?? SKKInputSessionBridge(client: client, layoutManager: layoutManager)
            self.skkMenu = skkMenu
            modeIcon = MacInputModeWindow(layoutManager)
            inputModeMenu = MacInputModeMenu(skkMenu)
            self.layoutManager = layoutManager

            self.session?.addListener(with: &modeIcon!)
            self.session?.addListener(with: &inputModeMenu!)
        } else {
            self.client = nil
            self.session = nil
            skkMenu = nil
            modeIcon = nil
            inputModeMenu = nil
            layoutManager = nil
        }

        blacklistApps = BlacklistApps.shared()
        preProcessor = SKKPreProcessor.shared()
    }

    deinit {
        Logger.skkMemory.debug("\(#function, privacy: .public))")

        // SKKInputSessionのデストラクタで各リスナーのSKKWidgetHide()を呼ぶので先に解放する
        session = nil

        modeIcon = nil
        inputModeMenu = nil
    }

    // MARK: - IMKServerInput

    override public func handle(_ event: NSEvent!, client _: Any!) -> Bool {
        Logger.skkIMK.info("[\(#fileID, privacy: .public):\(#function, privacy: .public)]")
        guard !directMode else {
            return false
        }
        var inputMode = skkMenu?.currentInputMode

        if let bundle = currentBundle,
           let blacklistApps = blacklistApps,
           blacklistApps.needsSyncInputSource(bundle: bundle)
        {
            if let currentInputSource = syncInputSource() {
                inputMode = currentInputSource
            }
        }

        guard let preProcessor = preProcessor else {
            Logger.skkInput.error("\(#function, privacy: .public) SKKPreProcessor isn't initialized.")
            return false
        }
        var param = preProcessor.execute(event: event)
        modeIcon?.SelectInputMode(.InvalidInputMode)
        let result = session?.handle(&param)
        if inputMode != skkMenu?.currentInputMode || param.id == SKK_JMODE {
            workaroundForSpecificApplications()
        }
        return result ?? false
    }

    override public func commitComposition(_: Any!) {
        Logger.skkIMK.info("[\(#fileID, privacy: .public):\(#function, privacy: .public)]")
        session?.commit()
    }

    // MARK: - IMKStateSetting

    override public func activateServer(_: Any!) {
        Logger.skkIMK.info("[\(#fileID, privacy: .public):\(#function, privacy: .public)]")
        UserDefaults.resetStandardUserDefaults()

        guard !directMode else {
            return
        }
        session?.activate()
    }

    override public func deactivateServer(_: Any!) {
        Logger.skkIMK.info("[\(#fileID, privacy: .public):\(#function, privacy: .public)]")

        guard !directMode else {
            return
        }
        session?.deactivate()
    }

    override public func setValue(_ value: Any!, forTag tag: Int, client _: Any!) {
        Logger.skkIMK.log("[\(#fileID, privacy: .public):\(#function, privacy: .public)] value: \(String(describing: value), privacy: .private), tag: \(tag, privacy: .public)")
        guard !directMode else {
            return
        }
        guard tag == kTextServiceInputModePropertyTag else {
            return
        }

        guard let value = value as? String else {
            return
        }

        guard let skkMenu = skkMenu else {
            return
        }

        // 「AquaSKK 統合」の場合
        if skkMenu.convertIDToEventID(modeIdentifier: value) == SKK_NULL {
            let indivisual = UserDefaults.standard.bool(forKey: SKKUserDefaultKeys.use_individual_input_mode)

            // SelectInputMode → setValue の無限ループが発生するため、
            // 最初の一回だけに限定する
            if activated {
                activated = true

                if indivisual {
                    let identifier = skkMenu.convertInputModeToID(inputMode: skkMenu.currentInputMode)
                    var param = SKKEvent()
                    param.id = Int32(skkMenu.convertIDToEventID(modeIdentifier: identifier))
                    session?.handle(&param)

                    modeIcon?.getImpl().select(inputMode: skkMenu.currentInputMode)
                } else {
                    let identifier = skkMenu.convertInputModeToID(inputMode: skkMenu.unifiedInputMode)
                    var param = SKKEvent()
                    param.id = Int32(skkMenu.convertIDToEventID(modeIdentifier: identifier))
                    session?.handle(&param)
                }
            }
        } else {
            // 個々の入力モードを選択している場合
            changeInputMode(value)
        }
    }

    // MARK: - IMKInputController

    override public func menu() -> NSMenu! {
        func item(title: String, action: Selector, isOn: (() -> Bool)? = nil) -> NSMenuItem {
            let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
            item.target = self
            if let isOn = isOn, isOn() {
                item.state = .on
            }
            return item
        }

        let workspace = NSWorkspace.shared
        var title = "直接入力モード"
        if let bundleIdentifier = client?.bundleIdentifier(),
           let url = workspace.urlForApplication(withBundleIdentifier: bundleIdentifier)
        {
            let name = FileManager.default.displayName(atPath: url.path)
            title = "\(name)では直接入力"
        }

        let inputMenu = NSMenu(title: "AquaSKK")

        for item in [
            item(title: "環境設定", action: #selector(launchPreferences)),
            item(title: title, action: #selector(toggleDirectMode), isOn: { self.directMode }),
            item(title: "プライベートモード", action: #selector(togglePrivateMode), isOn: { self.privateMode }),
            item(title: "設定ファイルの再読み込み", action: #selector(releodComponents)),
            item(title: "デバッグ情報", action: #selector(showDebugInfo)),
            NSMenuItem.separator(),
            item(title: "Github", action: #selector(github)),
        ] {
            inputMenu.addItem(item)
        }
        return inputMenu
    }

    @objc public func launchPreferences() {
        guard let path = Bundle.main.sharedSupportPath else {
            Logger.skkInput.error("\(#function, privacy: .public) sharedSupportPath is nil")
            return
        }
        NSWorkspace.shared.open(URL(fileURLWithPath: "\(path)/AquaSKKPreferences.app"))
    }

    @objc func releodComponents() {
        proxy?.reloadComponents()
    }

    @objc func showDebugInfo() {
        var rect: NSRect = .zero
        let attributes = client?.attributes(forCharacterIndex: 0, lineHeightRectangle: &rect)
        let info = """
        bundleIdentifier = \(client?.bundleIdentifier() ?? "")
        attributes = \(String(describing: attributes))
        inline rect = \(rect)
        selected range = \(String(describing: client?.selectedRange()))
        marked range = \(String(describing: client?.markedRange()))
        supports unicode = \(String(describing: client?.supportsUnicode()))
        window level = \(String(describing: client?.windowLevel()))
        length = \(String(describing: client?.length()))
        valid attributes = \(client?.validAttributesForMarkedText().debugDescription ?? "")
        """

        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = "デバッグ情報"
        alert.informativeText = info
        alert.alertStyle = .informational
        alert.icon = NSImage(named: NSImage.infoName)
        alert.window.level = .popUpMenu
        alert.window.title = "AquaSKK"
        if let window = NSApplication.shared.mainWindow {
            // TODO: pass nil
            alert.beginSheetModal(for: window)
        }
        let pb = NSPasteboard.general
        pb.declareTypes([.string], owner: self)
        pb.setString(info, forType: .string)
    }

    @objc func github() {
        if let url = URL(string: "https://github.com/codefirst/aquaskk") {
            NSWorkspace.shared.open(url)
        }
    }

    // MARK: - Workaround

    func isBlacklistedApp(bundle: Bundle) -> Bool {
        if let identifier = client?.bundleIdentifier() {
            if identifier == "com.apple.javajdk" {
                // Javaを直接起動している
                return true
            }
            if identifier == "net.java.openjdk" {
                // OpenJDKを使っている
                return true
            }
        }
        return blacklistApps?.needsInsertEmptyString(bundle: bundle) ?? false
    }

    func syncInputSource() -> SKKInputMode? {
        guard let modeIdentifier = context?.selectedKeyboardInputSource else {
            return nil
        }
        let system = skkMenu?.convertIDToInputMode(modeIdentifier: modeIdentifier)
        let current = skkMenu?.currentInputMode

        // AquaSKK統合の場合、systemがSKKInputMode::InvalidInputModeになるので、そのときは無視する
        if system == .InvalidInputMode {
            return current
        }

        // AquaSKKの制御外で入力モードが変更されている
        if system != current, let inputSourceID = context?.selectedKeyboardInputSource {
            changeInputMode(inputSourceID)
            return system
        }

        return nil
    }

    func changeInputMode(_ identifier: String) {
        guard let skkMenu = skkMenu else {
            Logger.skkInput.error("\(#function, privacy: .public): skkMenu is nil")
            return
        }
        var event = SKKEvent()

        // ex) "com.apple.inputmethod.Roman" => SKK_ASCII_MODE
        event.id = Int32(skkMenu.convertIDToEventID(modeIdentifier: identifier))

        // setValue内でメニューの更新があると、 selectInputMode -> setValueの無限ループが発生するため、
        // 更新を停止する
        skkMenu.deactivation()
        defer { skkMenu.activation() }
        if event.id != SKKInputMode.InvalidInputMode.rawValue {
            session?.handle(&event)
            let inputMode = skkMenu.convertIDToInputMode(modeIdentifier: identifier)
            modeIcon?.getImpl().select(inputMode: inputMode)
        }
    }

    func isBlacklisted() -> Bool {
        guard let bundle = currentBundle else {
            Logger.skkInput.warning("\(#function, privacy: .public): currentBundle is nil")
            return false
        }
        guard let blacklistApps = blacklistApps else {
            Logger.skkInput.warning("\(#function, privacy: .public): BlacklistApps is nil")
            return false
        }
        return blacklistApps.needsSyncInputSource(bundle: bundle)
    }

    func workaroundForSpecificApplications() {
        guard let bundle = currentBundle else {
            Logger.skkInput.warning("\(#function, privacy: .public): currentBundle is nil")
            return
        }
        guard let blacklistApps = blacklistApps else {
            Logger.skkInput.warning("\(#function, privacy: .public): BlacklistApps is nil")
            return
        }

        guard blacklistApps.needsInsertEmptyString(bundle: bundle) else {
            return
        }
        Logger.skkInput.log("\(#function, privacy: .public): cancel key event")

        // Ctrl-L を強制挿入することで、アプリケーション側のキー処理を無効化する
        let null = NSString(format: "%c", 0x0C)
        client().setMarkedText(null, selectionRange: .skkNotFound, replacementRange: .skkNotFound)
        client().setMarkedText("", selectionRange: .skkNotFound, replacementRange: .skkNotFound)
    }

    // MARK: - Property

    var privateMode: Bool {
        get {
            UserDefaults.standard.bool(forKey: SKKUserDefaultKeys.enable_private_mode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SKKUserDefaultKeys.enable_private_mode)
        }
    }

    @objc func togglePrivateMode() {
        privateMode.toggle()

        SKKBackendImpl.shared().privateModeEnabled = privateMode
    }

    @objc func toggleDirectMode() {
        directMode.toggle()
    }

    var directMode: Bool {
        get {
            guard let clients = UserDefaults.standard.array(forKey: SKKUserDefaultKeys.direct_clients) as? [String] else {
                return false
            }
            guard let identifier = client?.bundleIdentifier() else {
                return false
            }
            return clients.contains(identifier)
        }
        set {
            guard let identifier = client?.bundleIdentifier() else {
                return
            }

            var clients = UserDefaults.standard.array(forKey: SKKUserDefaultKeys.direct_clients) as? [String] ?? []

            if newValue {
                clients.append(identifier)
            } else {
                clients.removeAll {
                    identifier == $0
                }
            }
            UserDefaults.standard.set(clients, forKey: SKKUserDefaultKeys.direct_clients)
        }
    }

    var currentBundle: Bundle? {
        guard let identifier = client?.bundleIdentifier() else {
            return nil
        }
        let workspace = NSWorkspace.shared
        guard let path = workspace.urlForApplication(withBundleIdentifier: identifier) else {
            return nil
        }
        return Bundle(url: path)
    }
}
