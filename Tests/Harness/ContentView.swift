//
//  ContentView.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import AquaSKKIM
import SwiftUI

struct ContentView: View {
    @State var store = SKKStateStore()

    var body: some View {
        SKKContext.Server { server in
            SKKContext.InputController(server: server) { controller in
                Form {
                    SKKTextView(controller: controller, store: $store).frame(height: 40)
                        .padding(10)

                    Section("Client") {
                        InputModeMonitor(store: $store)
                        MenuMonitor(inputController: controller)
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
    ContentView()
}
