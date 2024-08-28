//
//  UICatalog.swift
//  Harness
//
//  Created by mzp on 8/27/24.
//

import AquaSKKUI
import SwiftUI

enum WindowType {
    case annotation
    case candidate
    case completion
    case inputMode
    case messenger
}

struct UICatalog: View {
    var annotation = AnnotationWindow.shared()!
    var candidate = CandidateWindow.shared()!
    var completion = CompletionWindow.shared()!
    var inputMode = InputModeWindow.shared()!
    var messenger = MessengerWindow.shared()!

    @State var point: CGPoint = .zero
    @State var selection: WindowType = .annotation
    var body: some View {
        Section("UI") {
            LabeledContent("Catalog") {
                VStack(spacing: 30) {
                    AppKitAnnotationView(definition: "AquaSKK", optional: "Input method")
                        .frame(height: 150)
                    AppKitCompletionView(completion: "AquaSKK").frame(height: 20)
                    AppKitCandidateView()
                    AppKitMessengerView(message: "Hello from AquaSKK")
                }
            }
            Picker("Window", selection: $selection) {
                Text("Annotation").tag(WindowType.annotation)
                Text("Candidate").tag(WindowType.candidate)
                Text("Completion").tag(WindowType.completion)
                Text("InputMode").tag(WindowType.inputMode)
                Text("Messenger").tag(WindowType.messenger)
            }
            LabeledContent("Control") {
                Button("Show") {
                    switch selection {
                    case .annotation:
                        annotation.setAnnotation("annotation", optional: "optional")
                        annotation.show(at: point, level: 0)

                    case .candidate:
                        candidate
                            .prepare(
                                with: NSFont.systemFont(ofSize: 12),
                                labels: "ABCDEF"
                            )
                        candidate.setCandidates([
                            "foo",
                            "bar",
                            "baz",
                            "xyzzy",
                        ], selectedIndex: 0)
                        candidate.setPage(NSRange(location: 1, length: 5))
                        candidate.show(at: point, level: 0)

                    case .completion:
                        completion
                            .showCompletion(
                                NSAttributedString("Completion"),
                                at: point,
                                level: 0
                            )

                    case .inputMode:
                        inputMode.show(at: point, level: 0)

                    case .messenger:
                        messenger.showMessage("Hello World", at: point, level: 0)
                    }
                }
                Button("Hide") {
                    self.annotation.hide()
                    self.candidate.hide()
                    self.completion.hide()
                    self.inputMode.hide()
                    self.messenger.hide()
                }
            }
        }.onAppear {
            let size = NSScreen.main?.frame.size ?? .zero
            point = .init(x: size.width / 2, y: size.height / 2)
        }
    }
}

#Preview {
    Form {
        UICatalog()
    }.formStyle(.grouped)
}
