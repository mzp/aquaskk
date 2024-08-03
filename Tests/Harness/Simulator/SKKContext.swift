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

enum SKKContext {
    struct Server: View {
        var server: SKKServer
        var content: (SKKServer) -> any View

        let signposter = OSSignposter(subsystem: "org.codefirst.AquaSKK.Harness", category: "Server")
        let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "Server")

        init(content: @escaping (SKKServer) -> any View) {
            server = SKKServer()
            self.content = content
            logger.info("start")
            let id = signposter.makeSignpostID()
            let state = signposter.beginInterval("start", id: id)
            server._start()
            signposter.endInterval("start", state)
        }

        var body: some View {
            AnyView(content(server))
        }
    }

    struct InputController: View {
        var server: SKKServer
        var inputController: SKKInputController
        var content: (SKKInputController) -> any View

        init(server: SKKServer, content: @escaping (SKKInputController) -> any View) {
            self.server = server
            inputController = SKKInputController()
            self.content = content
        }

        var body: some View {
            AnyView(content(inputController))
        }
    }
}
