//
//  SKKRecursiveEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/10.
//

public class SKKRecursiveEditorImpl {
    private let env: SKKInputEnvironmentImpl
    private var annotator: SKKAnnotatorProtocol
    private var completer: SKKDynamicCompletorProtocol
    private var candidateWindow: SKKCandidateWindowProtocol
    private var state: SKKStateMachineImpl
    private var editor: SKKInputEngineImpl
    public init(env: SKKInputEnvironment) {
        let envImpl = env.getImpl()!
        let editorImpl = SKKInputEngineImpl(env: envImpl)
        let completerImpl = SKKCompleterImpl(buddyProtocol: editorImpl)
        let selectorImpl = SKKSelectorImpl(buddy: editorImpl, presenter: envImpl.candidateWindow)
        editor = editorImpl
        self.env = envImpl
        annotator = envImpl.annotator
        completer = envImpl.dynamicCompletor
        candidateWindow = envImpl.candidateWindow
        state = SKKStateMachineImpl(engine: editorImpl, context: env.InputContext(), config: env.Config(), completer: completerImpl, selector: selectorImpl, messenger: envImpl.messenger)
    }

    deinit {
        annotator.hide()
        completer.hide()
        candidateWindow.hide()
        env.selector.Hide()
    }

    public func input(event: SKKEvent) {
        state.dispatch(event: event)
    }

    public func output() {
        editor.updateInputContext()
        env.context.output.Output()

        if env.context.dynamic_completion, env.config.enableDynamicCompletion() {
            let entry = env.context.entry
            var joined = ""
            var commonPrefix = ""
            if !entry.IsEmpty(), !entry.IsOkuriAri() {
                let range = env.config.dynamicCompletionRange()
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

            completer.update(completion: joined, commonPrefixLength: commonPrefix.count, cursorOffset: Int(env.context.output.GetMark()))
            completer.show()
        } else {
            completer.hide()
        }

        if env.context.annotation, env.config.enableAnnotation() {
            let candidate = env.context.candidateBridge

            annotator.update(candidateBridge: candidate!, cursorOffset: Int(env.context.output.GetMark()))
            annotator.show()
        } else {
            annotator.hide()
        }
    }

    public func activate() {
        annotator.activate()
        completer.activate()
        candidateWindow.activate()
        env.selector.Activate()
    }

    public func deactivate() {
        annotator.deactivate()
        completer.deactivate()
        candidateWindow.deactivate()
        env.selector.Deactivate()
    }
}
