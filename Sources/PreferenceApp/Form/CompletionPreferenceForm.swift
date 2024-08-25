//
//  CompletionPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct CompletionPreferenceForm: View {
    @EnvironmentObject var store: PreferenceStore

    var body: some View {
        Form {
            Section("Completion") {
                // FIXME: What is 一般辞書?
                Toggle("Include User dictionary", isOn: $store.enableExtendedCompletion)
                LabeledContent("Minimum Length", content: {
                    VStack(alignment: .trailing) {
                        Slider(value: Binding(get: { Float(store.minimumCompletionLength) }, set: { store.minimumCompletionLength = Int($0) }))
                        Text("Ignore characters less than equal \(store.minimumCompletionLength)")
                    }
                }).disabled(!store.enableExtendedCompletion)
            }

            Section("Dynamic Completion") {
                Toggle("Enable", isOn: $store.enableDynamicCompletion)
                LabeledContent("Max count", content: {
                    Stepper("Word(s)", value: $store.dynamicCompletionRange)
                }).disabled(!store.enableDynamicCompletion)
            }
        }
    }
}

#Preview {
    CompletionPreferenceForm()
        .environmentObject(PreferenceStore.default)
        .formStyle(.grouped)
}
