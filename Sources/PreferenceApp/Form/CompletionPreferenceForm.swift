//
//  CompletionPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct CompletionPreferenceForm: View {
    @ObservedObject private var storage = PreferenceStore.default

    var body: some View {
        Form {
            Section("Completion") {
                // FIXME: What is 一般辞書?
                Toggle("Include User dictionary", isOn: $storage.enableExtendedCompletion)
                LabeledContent("Minimum Length", content: {
                    VStack(alignment: .trailing) {
                        Slider(value: Binding(get: { Float(storage.minimumCompletionLength) }, set: { storage.minimumCompletionLength = Int($0) }))
                        Text("Ignore characters less than equal \(storage.minimumCompletionLength)")
                    }
                }).disabled(!storage.enableExtendedCompletion)
            }

            Section("Dynamic Completion") {
                Toggle("Enable", isOn: $storage.enableDynamicCompletion)
                LabeledContent("Max count", content: {
                    Stepper("Word(s)", value: $storage.dynamicCompletionRange)
                }).disabled(!storage.enableDynamicCompletion)
            }
        }
    }
}

#Preview {
    CompletionPreferenceForm().formStyle(.grouped)
}
