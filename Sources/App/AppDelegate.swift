//
//  AppDelegate.swift
//  EmojiIM
//
//  Created by mzp on 2017/09/11.
//  Copyright © 2017 mzp. All rights reserved.
//

internal import AquaSKKInput
import Cocoa
import OSLog

private let logger = Logger(subsystem: "com.aquaskk.inputmethod", category: "App")

@objc(AppDelegate) class AppDelegate: NSObject, NSApplicationDelegate {
    var server: SKKServer?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        logger.log("\(#function, privacy: .public): AquaSKK Launch:\(aNotification)")
        server = SKKServer()
        server?.awakeFromNib()
    }

    func applicationWillTerminate(_: Notification) {}
}
