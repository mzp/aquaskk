//
//  SKKRecursiveEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/10.
//

public class SKKRecursiveEditorImpl {
    private let env: SKKInputEnvironment
    private var annotator: SKKAnnotatorProtocol
    private var completer: SKKDynamicCompletor
    private var candidateWindow: SKKCandidateWindow
    private var state: SKKStateMachineImpl
    private var editor: SKKInputEngineImpl
    public init(env: SKKInputEnvironment) {
        let envImpl = env.getImpl()!
        let editorImpl = SKKInputEngineImpl(env: envImpl)
        let completerImpl = SKKCompleterImpl(buddyProtocol: editorImpl)
        let selectorImpl = SKKSelectorImpl(buddy: editorImpl, presenter: SKKCandidateWindowBridgeAdapter(env.CandidateWindowBridge()!))
        editor = editorImpl
        self.env = env
        annotator = envImpl.annotator
        completer = env.DynamicCompletor()
        candidateWindow = env.CandidateWindow()
        state = SKKStateMachineImpl(engine: editorImpl, context: env.InputContext(), config: env.Config(), completer: completerImpl, selector: selectorImpl, messenger: env.Messenger())
    }

    deinit {
        annotator.hide()
        completer.Hide()
        candidateWindow.Hide()

        var selector = env.InputModeSelector()
        selector?.Hide()
    }

    public func input(event: SKKEvent) {
        state.dispatch(event: event)
    }

    public func output() {
        editor.updateInputContext()
        guard let context = env.InputContext() else {
            return
        }

        context.output.Output()

        if context.dynamic_completion, env.Config().EnableDynamicCompletion() {
            let entry = context.entry
            var joined = ""
            var commonPrefix = ""
            if !entry.IsEmpty(), !entry.IsOkuriAri() {
                let range = env.Config().DynamicCompletionRange()
                let key = String(entry.EntryString())

                if range > 0 {
                    let result = SKKBackendImpl.shared().complete(key: key, limit: Int(range))
                    joined = result.joined(separator: "\n")

                    if !result.isEmpty {
                        commonPrefix = result.reduce(result[0]) {
                            $0.commonPrefix(with: $1)
                        }
                    }
                }
            }
            SKKDynamicCompletor.InvokeUpdate(completer, std.string(joined), Int32(commonPrefix.count), context.output.GetMark())
            completer.Show()
        } else {
            completer.Hide()
        }

        if context.annotation, env.Config().EnableAnnotation() {
            let candidate = context.candidateBridge

            annotator.update(candidateBridge: candidate!, cursorOffset: Int(context.output.GetMark()))
            annotator.show()
        } else {
            annotator.hide()
        }
    }

    public func activate() {
        annotator.activate()
        completer.Activate()
        candidateWindow.Activate()
        var selector = env.InputModeSelector()
        selector?.Activate()
    }

    public func deactivate() {
        annotator.deactivate()
        completer.Deactivate()
        candidateWindow.Deactivate()
        var selector = env.InputModeSelector()
        selector?.Deactivate()
    }
}
