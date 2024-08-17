//
//  SKKContext.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import AquaSKKIM
import Foundation
import OSLog
import SwiftUI

private let signposter = OSSignposter(subsystem: "com.aquaskk.inputmethod.Harness", category: "Context")
private let logger = Logger(subsystem: "com.aquaskk.inputmethod.Harness", category: "Context")

enum SKKContext {
    struct Server: View {
        var server: SKKServer
        var content: (SKKServer) -> any View
        let configuration = BundledServerConfiguration()
        init(content: @escaping (SKKServer) -> any View) {
            server = SKKServer()
            self.content = content
            signposter.withIntervalSignpost("server start") {
                logger.info("server start")
                server._start(with: configuration)
            }
        }

        var body: some View {
            AnyView(content(server))
        }
    }

    struct InputController: View {
        var server: SKKServer
        var content: (SKKInputController) -> any View
        var inputController = SKKInputController()

        var body: some View {
            AnyView(content(inputController))
        }
    }
}
