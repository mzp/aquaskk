//
//  AppKitAnnotationView.swift
//  Harness
//
//  Created by mzp on 8/27/24.
//

import AquaSKKUI
import SwiftUI

struct AppKitAnnotationView: NSViewRepresentable {
    var definition: String
    var optional: String
    func makeNSView(context _: Context) -> AnnotationView {
        AnnotationView()
    }

    func updateNSView(_ nsView: AnnotationView, context _: Context) {
        nsView.setAnnotation(definition, optional: optional)
    }
}

#Preview {
    AppKitAnnotationView(definition: "Hello", optional: "World")
}
