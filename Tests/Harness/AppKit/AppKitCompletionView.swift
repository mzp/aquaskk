//
//  AppKitCompletionView.swift
//  Harness
//
//  Created by mzp on 8/27/24.
//

import AquaSKKUI
import SwiftUI

struct AppKitCompletionView: NSViewRepresentable {
    var completion: AttributedString
    func makeNSView(context _: Context) -> CompletionView {
        return CompletionView()
    }

    func updateNSView(_ nsView: CompletionView, context _: Context) {
        nsView.setCompletion(NSAttributedString(completion))
    }
}

#Preview {
    AppKitCompletionView(completion: AttributedString("Aqua*SKK*"))
}
