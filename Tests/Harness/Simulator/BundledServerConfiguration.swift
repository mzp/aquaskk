//
//  BundledServerConfiguration.swift
//  AquaSKKService
//
//  Created by mzp on 8/14/24.
//

import AquaSKKService
import OSLog

private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "Configuratino")

class BundledServerConfiguration: ServerConfiguration {
    let bundle = Bundle(for: BundledServerConfiguration.self)
    func path(forName name: String) -> String {
        let basename = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        guard let path = bundle.path(forResource: basename, ofType: ext) else {
            logger.error("Can't find \(name)")
            return ""
        }
        return path
    }

    func systemPath(forName name: String) -> String {
        path(forName: name)
    }

    func userPath(forName name: String) -> String {
        path(forName: name)
    }

    func userDictionaryPath() -> String? {
        NSTemporaryDirectory().appending("/user-jisyo")
    }

    func systemDictionaries() -> [[AnyHashable: Any]] {
        let path = bundle.path(forResource: "SKK-JISYO.S", ofType: "txt")!
        return [
            Jisyo(type: .common, location: path, enabled: true).dictionary,
        ]
    }
}
