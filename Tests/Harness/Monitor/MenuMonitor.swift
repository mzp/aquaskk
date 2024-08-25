//
//  MenuMonitor.swift
//  Harness
//
//  Created by mzp on 8/17/24.
//

import AquaSKKIM
import SwiftUI

struct MenuMonitor: View {
    var inputController: SKKInputController
    @Binding var store: SKKStateStore

    var body: some View {
        if let menu = inputController.menu() {
            Section(menu.title) {
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
                }.pickerStyle(.inline)
                VStack(alignment: .leading) {
                    ForEach(Array(menu.items.enumerated()), id: \.offset) { _, item in
                        if item.isSeparatorItem {
                            Divider()
                        } else {
                            Button(item.title) {
                                let target = item.target ?? inputController
                                _ = target.perform(item.action)
                            }
                        }
                    }
                }.buttonStyle(.borderless)
            }
        } else {
            Text("Empty")
        }
    }
}

#Preview {
    MenuMonitor(
        inputController: SKKInputController(),
        store: .constant(SKKStateStore())
    )
    .formStyle(.grouped)
}
