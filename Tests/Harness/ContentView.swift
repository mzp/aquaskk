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
        VStack {
            SKKServerView { server in
                EmptyView()
            }
            SKKInputControllerView { controller in
                VStack {
                    SKKTextView(controller: controller)
                    HStack {
                        Button("Activate") {
                            controller.activateServer(nil)
                        }
                        Button("Deactivate") {
                            controller.deactivateServer(nil)
                        }
                    }

                }
            }
        }
    }
}

#Preview {
    ContentView()
}
