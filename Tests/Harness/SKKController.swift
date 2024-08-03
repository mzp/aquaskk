//
//  SKKMonitor.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import AquaSKKIM
import Foundation
import OSLog
import SwiftUI

struct SKKServerView: View {
    let server = SKKServer()
    var content: (SKKServer) -> any View
    let signposter = OSSignposter(subsystem: "org.codefirst.AquaSKK.Harness", category: "Server")
    let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "Server")

    var body: some View {
        AnyView(content(server))
        .onAppear {
            logger.info("start")
            let id = signposter.makeSignpostID()
            let state = signposter.beginInterval("start", id: id)
            server._start()
            signposter.endInterval("start", state)
        }
    }
}

struct SKKInputControllerView: View {
    var inputController = SKKInputController()
    var content: (SKKInputController) -> any View
    var body: some View {
        AnyView(content(inputController))
    }
}
