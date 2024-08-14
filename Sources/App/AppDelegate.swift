//
//  AppDelegate.swift
//  EmojiIM
//
//  Created by mzp on 2017/09/11.
//  Copyright © 2017 mzp. All rights reserved.
//

import Cocoa
import OSLog
import AquaSKKIM

private let logger = Logger(subsystem: "com.aquaskk.inputmethod", category: "App")

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var server: SKKServer?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        logger.info("\(#function): AquaSKK Launch:\(aNotification)")
        server = SKKServer()
        server?.awakeFromNib()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
}
