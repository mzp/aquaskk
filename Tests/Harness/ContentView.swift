//
//  ContentView.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import AquaSKKIM
import SwiftUI

struct ContentView: View {
    var body: some View {
        SKKContext.Server { server in
            SKKContext.InputController(server: server) { controller, stateStore in
                Form {

                    SKKTextView(controller: controller, stateStore: stateStore).frame(height: 40)
                        .padding(10)

                    Section("Client") {
                        StateMonitor(store: stateStore)
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
