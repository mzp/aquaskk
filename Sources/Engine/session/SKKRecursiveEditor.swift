//
//  SKKRecursiveEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/10.
//

public class SKKRecursiveEditorImpl {
    private let env: SKKInputEnvironment
    private var annotator: SKKAnnotator
    private var completer: SKKDynamicCompletor
    private var candidateWindow: SKKCandidateWindow
    private var state: SKKStateMachineImpl

    public init(env: SKKInputEnvironment, annotator: SKKAnnotator, dynamicCompleter: SKKDynamicCompletor, completer: SKKCompleter, candidateWindow: SKKCandidateWindow, editor: SKKInputEngine, selector: SKKSelector, messgenger: SKKMessenger) {
        self.env = env
        self.annotator = annotator
        self.completer = dynamicCompleter
        self.candidateWindow = candidateWindow
        state = SKKStateMachineImpl(engine: editor, context: env.InputContext(), config: env.Config(), completer: completer, selector: selector, messenger: messgenger)
    }

    deinit {
        annotator.Hide()
        completer.Hide()
        candidateWindow.Hide()

        var selector = env.InputModeSelector()
        selector?.Hide()
    }

    public func input(event: SKKEvent) {
        state.dispatch(event: event)
    }

    public func output() {
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
            let candidate = context.candidate
            SKKAnnotator.InvokeUpdate(annotator, candidate, context.output.GetMark())
            annotator.Show()
        } else {
            annotator.Hide()
        }
    }

    public func activate() {
        annotator.Activate()
        completer.Activate()
        candidateWindow.Activate()
        var selector = env.InputModeSelector()
        selector?.Activate()
    }

    public func deactivate() {
        annotator.Deactivate()
        completer.Deactivate()
        candidateWindow.Deactivate()
        var selector = env.InputModeSelector()
        selector?.Deactivate()
    }
}
