//
//  JisyoMonitor.swift
//  Harness
//
//  Created by mzp on 8/13/24.
//

import AquaSKKIM
import AquaSKKIM_Private
import AquaSKKService
import OSLog
import SwiftUI

private let signposter = OSSignposter(subsystem: "org.codefirst.AquaSKK.Harness", category: "Jisyo")
private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "Jisyo")

class JisyoResource: NSObject {
    static let shared = JisyoResource()
    var bundle: Bundle { Bundle(for: Self.self) }
    var jisyoPath: String {
        bundle.path(forResource: "SKK-JISYO.S", ofType: "txt")!
    }
}

struct JisyoMonitor: View {
    var server: SKKServer?
    @State var systemJisyos: [Jisyo] = [
        .init(type: .common, location: JisyoResource.shared.jisyoPath, enabled: true),
    ]

    var body: some View {
        Section("Jisyo") {
            VStack {
                List(systemJisyos) { jisyo in
                    Text(filename(jisyo.displayLocation))
                }
            }
            Button("Load", systemImage: "books.vertical", action: load)
        }.onAppear(perform: load)
    }

    func load() {
        guard let server = server else {
            return
        }
        let systemDictionaries = systemJisyos.map { $0.dictionary }

        signposter.withIntervalSignpost("Load Dictionary Set") {
            logger.info("load \(systemDictionaries)")
            server.loadDictionarySet(fromPath: nil, systemDictionaries: systemDictionaries)
        }
    }

    private func filename(_ string: String) -> String {
        (string as NSString).lastPathComponent
    }
}

#Preview {
    JisyoMonitor().formStyle(.grouped)
}
