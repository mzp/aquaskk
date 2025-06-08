//
//  SKKInputEngine.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

@objc public class SKKInputEngineImpl: NSObject, SKKCompleterBuddyProtcol, SKKSelectorBuddyProtocol, SKKOkuriListenerProtocol, SKKInputQueueObserverProtocol {
    private var env: SKKInputEnvironmentImpl
    private var context: SKKInputContext {
        env.context
    }

    @objc public init(env: SKKInputEnvironmentImpl) {
        self.env = env
        stack = []

        let context = env.context
        primaryEditor = .init(context: context)
        registerEditor = .init(context: context)
        composingEditor = .init(context: context)
        candidateEditor = .init(context: context)
        okuriEditor = .init(context: context)
        entryRemoveEditor = .init(context: context)
        inputQueue = .init()
        word = ""
        inputState = .init()

        super.init()
        setStatePrimary()

        okuriEditor.listener = self
        inputQueue.observer = self
    }

    // MARK: - 入力モード

    @objc public func selectInputMode(inputMode: SKKInputMode) {
        env.selector.Select(inputMode)
        inputQueue.selectInputMode(inputMode: inputMode)
        context.event_handled = true
    }

    @objc public func bridgedSelectInputMode(_ inputMode: Int32) {
        if let inputMode = SKKInputMode(rawValue: inputMode) {
            selectInputMode(inputMode: inputMode)
        }
    }

    // MARK: - 状態変更

    private let candidateEditor: SKKCandidateEditorImpl
    private let composingEditor: SKKComposingEditorImpl
    private let entryRemoveEditor: SKKEntryRemoveEditorImpl
    private let okuriEditor: SKKOkuriEditorImpl
    private let primaryEditor: SKKPrimaryEditorImpl
    private let registerEditor: SKKRegisterEditorImpl
    private var inputState: SKKInputQueueObserverState

    private var stack: [SKKEditorProtocol]

    private var top: SKKEditorProtocol? {
        stack.last
    }

    private func push(editor: SKKEditorProtocol) {
        stack.append(editor)
    }

    @objc public func setStatePrimary() {
        run {}
    }

    @objc public func setStateComposing() {
        run {
            push(editor: composingEditor)
            var entry = context.entry

            if !env.config.deleteOkuriWhenQuit() {
                entry.AppendEntry(entry.OkuriString())
            }
        }
    }

    @objc public func setStateOkuri() {
        run {
            push(editor: composingEditor)
            push(editor: okuriEditor)
        }
    }

    @objc public func setStateSelectCandidate() {
        run {
            push(editor: candidateEditor)
        }
    }

    @objc public func setStateEntryRemove() {
        run {
            push(editor: entryRemoveEditor)
        }
    }

    @objc public func setStateRegistration() {
        updateInputContext()
        context.registration.Start()
    }

    func run(perform: () -> Void) {
        // 直近の状態を SKKInputContext に反映する
        updateInputContext()

        // 初期化
        stack.removeAll()

        if env.isPrimaryEditor {
            push(editor: primaryEditor)
        } else {
            push(editor: registerEditor)
        }
        context.dynamic_completion = true
        context.annotation = false

        if context.registration.state == .Aborted {
            context.registration.Clear()
            env.selector.Refresh()
        }

        perform()

        // Top エディタを初期化する
        top?.readContext()

        // 最新の状態を SKKInputContext に反映する
        updateInputContext()
    }

    // MARK: - 入力

    private let inputQueue: SKKInputQueueImpl
    private var word: String

    @objc public func handleChar(code: Int, direct: Bool) {
        inputQueue.addChar(character: code, direct: direct)
    }

    @objc public func handleBackSpace() {
        if inputQueue.isEmpty {
            invoke(event: SKKBaseEditorEventBackSpace)
        } else {
            inputQueue.removeChar()
        }
    }

    @objc public func handleDelete() {
        invoke(event: SKKBaseEditorEventDelete)
    }

    @objc public func handleCursorLeft() {
        invoke(event: SKKBaseEditorEventCursorLeft)
    }

    @objc public func handleCursorRight() {
        invoke(event: SKKBaseEditorEventCursorRight)
    }

    @objc public func handleCursorUp() {
        invoke(event: SKKBaseEditorEventCursorUp)
    }

    @objc public func handleCursorDown() {
        invoke(event: SKKBaseEditorEventCursorDown)
    }

    @objc public func handlePaste() {
        top?.input(ascii: env.pasteString)
    }

    @objc public func handlePing() {
        env.selector.Show()
    }

    @objc public func handleEnter() {
        commit()
        let candidate = SKKCandidate(std.string(word), false)
        study(entry: context.entry, candidate: candidate)
        if word.isEmpty {
            context.registration.Abort()
        } else {
            let output = "\(word)\(String(context.entry.OkuriString()))"
            context.registration.Finish(std.string(output))
        }
        context.event_handled = false
    }

    @objc public func handleCancel() {
        if !inputQueue.isEmpty {
            terminate()
            return
        }
        context.registration.Abort()
        context.event_handled = false
    }

    private func terminate() {
        if env.config.fixIntermediateConversion() {
            inputQueue.terminate()
        } else {
            inputQueue.clear()
        }
    }

    private func invoke(event: SKKBaseEditorEvent) {
        if !inputQueue.isEmpty {
            inputQueue.clear()
            context.event_handled = false
        } else {
            top?.inputEvent(event: event)
        }
    }

    // MARK: - 確定

    @objc public func commit() {
        terminate()
        word.removeAll()

        // Top のフィルターから Commit していき、最終的な単語を取得する
        for editor in stack.reversed() {
            word = editor.commit(queue: word)
        }
    }

    // MARK: - リセット

    @objc public func reset() {
        terminate()
        context.event_handled = false
    }

    // MARK: - トグル変換

    var inputMode: SKKInputMode? {
        env.selector.inputMode
    }

    @objc public func toggleKana() {
        let entry = context.entry
        study(entry: entry, candidate: .init())
        if let inputMode = inputMode {
            let string = entry.ToggleKana(inputMode)
            insert(string: String(string))
        }
    }

    @objc public func toggleJisx0201Kana() {
        let entry = context.entry
        study(entry: entry, candidate: .init())
        if let inputMode = inputMode {
            let string = entry.ToggleJisx0201Kana(inputMode)
            insert(string: String(string))
        }
    }

    private func study(entry: SKKEntry, candidate: SKKCandidate) {
        if entry.IsEmpty() {
            return
        }
        if entry.IsOkuriAri(), entry.OkuriString().empty() {
            return
        }
        if entry.IsOkuriAri(), candidate.IsEmpty() {
            return
        }
        SKKBackendImpl.shared().register(entry: entry, candidate: candidate)
    }

    private func insert(string: String) {
        stack.first?.input(fixed: string, input: "", code: 0)
    }

    // MAKR: - 同期

    @objc public func updateInputContext() {
        context.output.clear()
        for editor in stack {
            editor.writeContext()
        }

        // 非確定文字があれば挿入(ex. "ky" など)
        if env.config.displayShortestMatchOfKanaConversions(), !inputState.intermediate.empty() {
            context.output.compose(string: SKKUTF8String(inputState.intermediate), cursor: 0)
        } else {
            context.output.compose(string: SKKUTF8String(inputState.queue), cursor: 0)
        }
        env.selector.Notify()
    }

    /// ローマ字かな変換が発生するか？
    @objc public func canConvert(code: Int) -> Bool {
        return inputQueue.canConvert(code: code)
    }

    /// 送りが完成したか？
    @objc public var isOkuriComplete: Bool {
        return okuriEditor.isOkuriComplete()
    }

    @objc public func bridgeInputQueueUpdate(fixed: String, intermediate: String, queue: String, code: Int) {
        let state = SKKInputQueueObserverState(fixed: std.string(fixed), intermediate: std.string(intermediate), queue: std.string(queue), code: CChar(code))
        inputQueueUpdate(state: state)
    }

    public func inputQueueUpdate(state: SKKInputQueueObserverState) {
        inputState = state
        if inputMode == .AsciiInputMode {
            top?.input(ascii: String(state.fixed))
        } else {
            top?.input(fixed: String(state.fixed), input: String(state.queue), code: Int(state.code))
        }
    }

    @objc public func completerQueryString() -> String {
        return String(selectorQueryEntry().EntryString())
    }

    @objc public func completerUpdate(entry: String) {
        composingEditor.setEntry(entry: entry)
    }

    func selectorQueryEntry() -> SKKEntry {
        terminate()
        guard let inputMode = inputMode else {
            return .init()
        }
        let entry = context.entry.Normalize(inputMode)
        context.entry = entry
        return entry
    }

    @objc public func bridgeSelectorQueryEntry() -> [String] {
        let entry = selectorQueryEntry()
        return [String(entry.EntryString()), String(entry.OkuriString())]
    }

    func selectorUpdate(candidate: SKKCandidate) {
        candidateEditor.setCandidate(candidate: candidate)
    }

    @objc public func okkuriListenerAppendEntry(fixed: String) {
        composingEditor.input(fixed: fixed, input: "", code: 0)
    }

    @objc public func getCompleterBuddyProtocol() -> SKKCompleterBuddyProtcol {
        return self
    }

    @objc public func getOkuriListenerProtocol() -> SKKOkuriListenerProtocol {
        return self
    }

    @objc public func getInputQueueObserverProtocol() -> SKKInputQueueObserverProtocol {
        return self
    }

    // MARK: - SKKSelectorBuddyProtocol

    @objc public func getSelectorBuddyProtocol() -> SKKSelectorBuddyProtocol {
        return self
    }

    @objc public func bridgeSelectorUpdate(candidate: String) {
        selectorUpdate(candidate: SKKCandidate(std.string(candidate), true))
    }
}
