//
//  FilePathTextField.swift
//  Preferences
//
//  Created by mzp on 8/10/24.
//

import OSLog
import SwiftUI

private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Preference", category: "Jisyo")

struct FilePathTextField: View {
    var titleKey: LocalizedStringKey
    @Binding var location: String
    @State private var isPresenting: Bool = false

    init(_ titleKey: LocalizedStringKey, location: Binding<String>) {
        self.titleKey = titleKey
        _location = location
    }

    var body: some View {
        LabeledContent(titleKey) {
            ZStack {
                TextField(titleKey, text: $location)
                    .labelsHidden()
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Spacer()
                    Button("Change ...", systemImage: "doc", action: {
                        isPresenting = true
                    }).labelStyle(.iconOnly)
                        .buttonStyle(.borderless)
                }
            }
        }
        .fileImporter(isPresented: $isPresenting, allowedContentTypes: [.data]) { path in
            switch path {
            case let .success(url):
                location = url.path
            case let .failure(error):
                logger.error("can't import file due to \(error, privacy: .public)")
            }
        }
    }
}

#Preview {
    FilePathTextField("Location", location: .constant("~/skk-jisyo"))
}
