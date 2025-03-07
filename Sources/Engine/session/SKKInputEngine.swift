//
//  SKKInputEngine.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

public class SKKInputEngineImpl {
    private var env: SKKInputEnvironment
    private var context: SKKInputContext {
        env.InputContext()
    }

    private let inputQueue: SKKInputQueueImpl
    private let composingEditor: SKKComposingEditorImpl
    private var word: String
    private let okuriEditor: SKKOkuriEditorImpl
    private let candidateEditor: SKKCandidateEditorImpl
    private let entryRemoveEditor: SKKEntryRemoveEditorImpl
    private var inputState: SKKInputQueueObserverState

    public init(env: SKKInputEnvironment, inputQueue: SKKInputQueueImpl, okuriEditor: SKKOkuriEditorImpl) {
        self.env = env
        stack = []
        composingEditor = .init(context: env.InputContext())
        candidateEditor = .init(context: env.InputContext())
        self.okuriEditor = okuriEditor
        entryRemoveEditor = .init(context: env.InputContext())
        self.inputQueue = inputQueue
        word = ""
        inputState = .init()
        setStatePrimary()
    }

    // MARK: - 入力モード

    public func selectInputMode(inputMode: SKKInputMode) {
        env.InputModeSelector().Select(inputMode)
        inputQueue.selectInputMode(inputMode: inputMode)
        context.event_handled = true
    }

    public func bridgedSelectInputMode(_ inputMode: Int32) {
        if let inputMode = SKKInputMode(rawValue: inputMode) {
            selectInputMode(inputMode: inputMode)
        }
    }

    // MARK: - 状態変更

    private var stack: [SKKEditorProtocol]

    private var top: SKKEditorProtocol? {
        stack.last
    }

    private func push(editor: SKKEditorProtocol) {
        stack.append(editor)
    }

    public func setStatePrimary() {
        run {}
    }

    public func setStateComposing() {
        run {
            push(editor: composingEditor)
            var entry = context.entry

            if !env.Config().DeleteOkuriWhenQuit() {
                entry.AppendEntry(entry.OkuriString())
            }
        }
    }

    public func setStateOkuri() {
        run {
            push(editor: composingEditor)
            push(editor: okuriEditor)
        }
    }

    public func setStateSelectCandidate() {
        run {
            push(editor: candidateEditor)
        }
    }

    public func setStateEntryRemove() {
        run {
            push(editor: entryRemoveEditor)
        }
    }

    public func setStateRegistration() {
        updateInputContext()
        context.registration.Start()
    }

    func run(perform: () -> Void) {
        // 直近の状態を SKKInputContext に反映する
        updateInputContext()

        // 初期化
        stack.removeAll()
        // stack_.push_back(env_->BaseEditor());

        context.dynamic_completion = true
        context.annotation = false

        if context.registration.state == SKKRegistrationAborted {
            context.registration.Clear()
            // env_->InputModeSelector()->Refresh();
        }

        perform()

        // Top エディタを初期化する
        top?.readContext()

        // 最新の状態を SKKInputContext に反映する
        updateInputContext()
    }

    // MARK: - 入力

    public func handleChar(code: Int, direct: Bool) {
        inputQueue.addChar(character: code, direct: direct)
    }

    public func handleBackSpace() {
        if inputQueue.isEmpty {
            invoke(event: SKKBaseEditorEventBackSpace)
        } else {
            inputQueue.removeChar()
        }
    }

    public func handleDelete() {
        invoke(event: SKKBaseEditorEventDelete)
    }

    public func handleCursorLeft() {
        invoke(event: SKKBaseEditorEventCursorLeft)
    }

    public func handleCursorRight() {
        invoke(event: SKKBaseEditorEventCursorRight)
    }

    public func handleCursorUp() {
        invoke(event: SKKBaseEditorEventCursorUp)
    }

    public func handleCursorDown() {
        invoke(event: SKKBaseEditorEventCursorDown)
    }

    public func handlePaste() {
        top?.input(ascii: String(env.PasteString()))
    }

    public func handlePing() {
        var inputModeSelector = env.InputModeSelector()
        inputModeSelector?.Show()
    }

    public func handleEnter() {
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

    public func handleCancel() {
        if !inputQueue.isEmpty {
            terminate()
            return
        }
        context.registration.Abort()
        context.event_handled = false
    }

    private func terminate() {
        if env.Config().FixIntermediateConversion() {
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

    public func commit() {
        terminate()
        word.removeAll()

        // Top のフィルターから Commit していき、最終的な単語を取得する
        for editor in stack.reversed() {
            word = editor.commit(queue: word)
        }
    }

    // MARK: - リセット

    public func reset() {
        terminate()
        context.event_handled = false
    }

    // MARK: - トグル変換

    var inputMode: SKKInputMode? {
        env.InputModeSelector()?.inputMode
    }

    public func toggleKana() {
        let entry = context.entry
        study(entry: entry, candidate: .init())
        if let inputMode = inputMode {
            let string = entry.ToggleKana(inputMode)
            insert(string: String(string))
        }
    }

    public func toggleJisx0201Kana() {
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

    public func updateInputContext() {
        context.output.Clear()
        for editor in stack {
            editor.writeContext()
        }

        // 非確定文字があれば挿入(ex. "ky" など)
        if env.Config().DisplayShortestMatchOfKanaConversions(), !inputState.intermediate.empty() {
            context.output.Compose(inputState.intermediate, 0)
        } else {
            context.output.Compose(inputState.queue, 0)
        }
        env.InputModeSelector().Notify()
    }

    /// ローマ字かな変換が発生するか？
    public func canConvert(code: Int) -> Bool {
        return inputQueue.canConvert(code: code)
    }

    /// 送りが完成したか？
    public var isOkuriComplete: Bool {
        return okuriEditor.isOkuriComplete()
    }

    public func inputQueueUpdate(state: SKKInputQueueObserverState) {
        inputState = state
        if inputMode == .AsciiInputMode {
            top?.input(ascii: String(state.fixed))
        } else {
            top?.input(fixed: String(state.fixed), input: String(state.queue), code: Int(state.code))
        }
    }

    public func completerQueryString() -> String {
        return String(selectorQueryEntry().EntryString())
    }

    public func completerUpdate(entry: String) {
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

    public func bridgeSelectorQueryEntry() -> [String] {
        let entry = selectorQueryEntry()
        return [String(entry.EntryString()), String(entry.OkuriString())]
    }

    public func bridgeSelectorUpdate(candidate: String) {
        selectorUpdate(candidate: SKKCandidate(std.string(candidate), true))
    }

    func selectorUpdate(candidate: SKKCandidate) {
        candidateEditor.setCandidate(candidate: candidate)
    }

    public func okkuriListenerAppendEntry(fixed: String) {
        composingEditor.input(fixed: fixed, input: "", code: 0)
    }
}
