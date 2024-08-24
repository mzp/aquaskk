//
//  GeneralPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct GeneralPreferenceForm: View {
    @ObservedObject private var storage = PreferenceStore.default

    var body: some View {
        Form {
            Section("Text Edit") {
                Toggle("Suppress newline on commit", isOn: $storage.suppressNewlineOnCommit)

                Toggle("Use numeric conversion", isOn: $storage.useNumericConversion)
                Toggle("Show input mode icon", isOn: $storage.showInputModeIcon)

                Toggle(isOn: $storage.useIndividualInputMode, label: {
                    HStack {
                        Text("Use indivisual input mode")
                        Text("(for unified mode)").bold()
                    }
                })

                Toggle("Beep on registration", isOn: $storage.beepOnRegistration)
            }

            Section("Keyboard Layout") {
                Picker("Layout", selection: $storage.keyboardLayout) {
                    ForEach(storage.availableKeyboardLayouts, id: \.inputSourceID, content: { layout in
                        Text(layout.localizedName).tag(layout.inputSourceID)
                    })
                }
            }
        }
    }
}

#Preview {
    GeneralPreferenceForm()
}
