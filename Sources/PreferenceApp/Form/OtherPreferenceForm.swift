
//
//  OtherPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct OtherPreferenceForm: View {
    @EnvironmentObject var store: PreferenceStore

    var body: some View {
        Form {
            Section("skkserve") {
                Toggle("Enable", isOn: $store.enableSkkserv)
                Toggle("Accept only localhost", isOn: $store.skkservLocalonly)
                TextField("Port", text: Binding(
                    get: { String(store.skkservPort) },
                    set: { store.skkservPort = Int($0) ?? store.skkservPort }
                ))
            }

            Section("Other") {
                Toggle("Display shorted match of kana converion", isOn: $store.displayShortestMatchOfKanaConversions)
                Toggle("Handle recursive entry as okuri", isOn: $store.handleRecursiveEntryAsOkuri)
                Toggle("No okuri when cancel", isOn: $store.deleteOkuriWhenQuit)
                Toggle("Commit with backspace", isOn: $store.inlineBackspaceImpliesCommit)
            }
        }
    }
}

#Preview {
    OtherPreferenceForm()
        .environmentObject(PreferenceStore.default)
        .formStyle(.grouped)
}
