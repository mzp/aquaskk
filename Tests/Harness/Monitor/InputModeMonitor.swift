//
//  InputModeMonitor.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import SwiftUI

struct InputModeMonitor: View {
    @Binding var store: SKKStateStore

    var body: some View {
        Section("State") {
            Picker("Input mode", selection: $store.modeIdentifier) {
                ForEach([
                    "com.apple.inputmethod.Japanese.Hiragana",
                    "com.apple.inputmethod.Japanese.Katakana",
                    "com.apple.inputmethod.Japanese.HalfWidthKana",
                    "com.apple.inputmethod.Japanese.FullWidthRoman",
                    "com.apple.inputmethod.Roman",
                    "com.apple.inputmethod.Japanese",
                ], id: \.self) { mode in
                    Text(mode).tag(mode)
                }
                Text("Unspecified").tag("")
            }
            LabeledContent("Keyboard", value: store.keyboardLayout)
        }
    }
}

#Preview {
    InputModeMonitor(store: .constant(SKKStateStore()))
}
