//
//  ContentView.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import AquaSKKInput
import SwiftUI

struct ContentView: View {
    @State var store = SKKStateStore()

    var body: some View {
        SKKContext.Server { server in
            SKKContext.InputController(server: server) { controller in
                Form {
                    SKKTextView(controller: controller, stateStore: store).frame(height: 40)
                        .padding(10)

                    Section("Client") {
                        StateMonitor(store: store)
                        UICatalog()
                        MenuMonitor(inputController: controller, store: $store)
                    }
                    Section("Server") {
                        SupervisorMonitor(supervisor: server)
                    }
                }
            }
            .formStyle(.grouped)
            .padding()
        }
    }
}

#Preview {
    ContentView(store: SKKStateStore())
}
