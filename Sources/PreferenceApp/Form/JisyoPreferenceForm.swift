//
//  JisyoPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/8/24.
//

import AquaSKKService
import OSLog
import SwiftUI

private let logger = Logger(subsystem: "com.aquaskk.inputmethod.Preference", category: "Jisyo")

struct JisyoPreferenceForm: View {
    @EnvironmentObject var store: PreferenceStore
    @State var selection: String?
    var body: some View {
        Form {
            Section("User Dictioanry") {
                UserJisyoPreferenceForm()
            }
            Section("System Dictionary") {
                VStack(alignment: .leading, spacing: 0) {
                    List(store.systemJisyos, selection: $selection) { jisyo in
                        SystemJisyoPreferenceForm(
                            jisyo: jisyo,
                            selected: selection == jisyo.id,
                            storage: store
                        ).tag(jisyo.id)
                    }.listStyle(.inset)
                }
                // TODO: Add/remove buttons
            }
        }
    }
}

#Preview {
    JisyoPreferenceForm()
        .environmentObject(PreferenceStore.default)
        .formStyle(.grouped)
}
