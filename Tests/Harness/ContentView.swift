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
            SKKContext.InputController(server: server) { controller in
                    Form {
                        Section {
                            SKKTextView(controller: controller).frame(height: 40)
                        }
                        Section("Server") {
                            SupervisorMonitor(supervisor: server).padding(.top, 10)
                        }
                        Spacer()
                    }
                    .formStyle(.grouped)
                    .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
