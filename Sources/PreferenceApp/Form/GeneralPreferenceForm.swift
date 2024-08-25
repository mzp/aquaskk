//
//  GeneralPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct GeneralPreferenceForm: View {
    @EnvironmentObject var store: PreferenceStore

    var body: some View {
        Form {
            Section("Text Edit") {
                Toggle("Suppress newline on commit", isOn: $store.suppressNewlineOnCommit)

                Toggle("Use numeric conversion", isOn: $store.useNumericConversion)
                Toggle("Show input mode icon", isOn: $store.showInputModeIcon)

                Toggle(isOn: $store.useIndividualInputMode, label: {
                    HStack {
                        Text("Use indivisual input mode")
                        Text("(for unified mode)").bold()
                    }
                })

                Toggle("Beep on registration", isOn: $store.beepOnRegistration)
            }

            Section("Keyboard Layout") {
                Picker("Layout", selection: $store.keyboardLayout) {
                    ForEach(store.availableKeyboardLayouts, id: \.inputSourceID, content: { layout in
                        Text(layout.localizedName).tag(layout.inputSourceID)
                    })
                }
            }
        }
    }
}

#Preview {
    GeneralPreferenceForm()
        .environmentObject(PreferenceStore.default)
}
