//
//  BundleResourceConfiguration.swift
//  AquaSKKCore
//
//  Created by mzp on 8/6/24.
//

import Foundation
import OSLog

private let logger = Logger(subsystem: "org.codefirst.AquaSKK", category: "Service")

public class BundleResourceConfiguration: NSObject, AISResourceConfiguration {
    private let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    public func path(forSystemResource path: String) -> String {
        self.path(forResource: path)
    }

    public func path(forUserResource path: String) -> String {
        self.path(forResource: path)
    }

    public func path(forResource path: String) -> String {
        let name = (path as NSString).deletingPathExtension
        let type = (path as NSString).pathExtension
        guard let resource = bundle.path(forResource: name, ofType: type) else {
            let bundle = self.bundle
            logger.error("Can't find \(path, privacy: .public) in \(bundle, privacy: .public)")
            return ""
        }
        return resource
    }
}
