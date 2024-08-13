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

private let signposter = OSSignposter(subsystem: "org.codefirst.AquaSKK.Harness", category: "Context")
private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "Context")

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
        var inputController: SKKInputController
        var stateStore: SKKStateStore
        var content: (SKKInputController, SKKStateStore) -> any View

        init(server: SKKServer, content: @escaping (SKKInputController, SKKStateStore) -> any View) {
            self.server = server
            inputController = SKKInputController()
            stateStore = SKKStateStore()
            self.content = content
        }

        var body: some View {
            AnyView(content(inputController, stateStore))
        }
    }
}
