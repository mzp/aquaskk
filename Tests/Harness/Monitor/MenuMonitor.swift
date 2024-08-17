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
    var body: some View {
        if let menu = inputController.menu() {
            Section(menu.title) {
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
    MenuMonitor(inputController: SKKInputController()).formStyle(.grouped)
}
