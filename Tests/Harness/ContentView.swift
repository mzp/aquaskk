//
//  ContentView.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import AquaSKKInput
import AquaSKKTesting
import SwiftUI

struct ContentView: View {
    @State var store = SKKStateStore()
    @State var configuration: ServerConfiguration = try! BundledServerConfiguration(
        bundle: HarnessBundle.bundle)

    var body: some View {
        SKKContext.Server(configuration: configuration) { server in
            SKKContext.InputController(server: server) { controller in
                Form {
                    SKKTextView(controller: controller, stateStore: store).frame(height: 40)
                        .padding(10)

                    Section("Server") {
                        SupervisorMonitor(
                            supervisor: server
                        )
                    }
                    Section("Client") {
                        StateMonitor(store: store)
                        MenuMonitor(inputController: controller, store: $store)
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
