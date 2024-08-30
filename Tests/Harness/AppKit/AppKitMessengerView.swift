//
//  AppKitMessengerView.swift
//  Harness
//
//  Created by mzp on 8/27/24.
//

import AquaSKKUI
import SwiftUI

struct AppKitMessengerView: NSViewRepresentable {
    var message: String
    func makeNSView(context _: Context) -> MessengerView {
        MessengerView()
    }

    func updateNSView(_ nsView: MessengerView, context _: Context) {
        nsView.setMessage(message)
    }
}

#Preview {
    AppKitMessengerView(message: "AquaSKK")
}
