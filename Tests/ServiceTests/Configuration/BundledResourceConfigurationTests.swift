//
//  SystemResourceConfigurationTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AquaSKKService
import Testing
@testable import Harness

class TestClass {}

struct BundledResourceConfigurationTests {
    let config = BundleResourceConfiguration(bundle: Bundle(for: TestClass.self))

    @Test func systemResource() {
        let plist = config.path(forSystemResource: "BundledResource.plist")
        #expect(FileManager.default.fileExists(atPath: plist))
    }

    @Test func userResource() {
        let plist = config.path(forUserResource: "BundledResource.plist")
        #expect(FileManager.default.fileExists(atPath: plist))
    }

    @Test func resource() {
        let plist = config.path(forResource: "BundledResource.plist")
        #expect(FileManager.default.fileExists(atPath: plist))
    }

}
