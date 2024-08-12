//
//  JisyoControllerTests.swift
//  ServiceTests
//
//  Created by mzp on 8/8/24.
//

import AquaSKKService
import Testing

struct JisyoControllerTests {
    func makeController() throws -> JisyoController {
        let path = try ServiceTesting.shared.path("DictionarySet.plist", writable: true)
        return JisyoController(path: path)
    }

    @Test func allJisyo() throws {
        let controller = try makeController()
        #expect(!controller.allJisyo.isEmpty)

        let jisyo = controller.allJisyo[0]
        #expect(jisyo.type == .common)
        #expect(jisyo.displayType == "SKK 辞書(EUC-JP)")
        #expect(jisyo.enabled == true)
        #expect(jisyo.displayLocation == "~/.skk-jisyo")

        controller.set(jisyo: jisyo, enabled: false)
        controller.set(jisyo: jisyo, type: .commonUTF8)
        #expect(jisyo.enabled == false)
        #expect(jisyo.type == .commonUTF8)

        let updated = JisyoController(path: controller.path).allJisyo[0]
        #expect(updated.enabled == false)
        #expect(updated.type == .commonUTF8)
    }

    @Test func append() throws {
        let controller = try makeController()
        let allJisyo = controller.allJisyo
        let jisyo = Jisyo(type: .common, location: "~/my-skk-jisyo", enabled: false)
        controller.append(jisyo)
        let newAllJisyo = controller.allJisyo

        #expect((allJisyo.count + 1) == newAllJisyo.count)
        #expect(newAllJisyo.last == jisyo)
    }
}
