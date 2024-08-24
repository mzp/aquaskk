
//
//  OtherPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct OtherPreferenceForm: View {
    @ObservedObject private var storage = PreferenceStore.default

    var body: some View {
        Form {
            Section("skkserve") {
                Toggle("Enable", isOn: $storage.enableSkkserv)
                Toggle("Accept only localhost", isOn: $storage.skkservLocalonly)
                TextField("Port", text: Binding(
                    get: { String(storage.skkservPort) },
                    set: { storage.skkservPort = Int($0) ?? storage.skkservPort }
                ))
            }

            Section("Other") {
                Toggle("Display shorted match of kana converion", isOn: $storage.displayShortestMatchOfKanaConversions)
                Toggle("Handle recursive entry as okuri", isOn: $storage.handleRecursiveEntryAsOkuri)
                Toggle("No okuri when cancel", isOn: $storage.deleteOkuriWhenQuit)
                Toggle("Commit with backspace", isOn: $storage.inlineBackspaceImpliesCommit)
            }
        }
    }
}

#Preview {
    OtherPreferenceForm().formStyle(.grouped)
}
