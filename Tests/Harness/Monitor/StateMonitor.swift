//
//  StateMonitor.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import SwiftUI

struct StateMonitor: View {
    var store: SKKStateStore

    var body: some View {
        Section("State") {
            LabeledContent("Keyboard", value: store.keyboardLayout)
        }
    }
}

#Preview {
    StateMonitor(store: SKKStateStore())
}
