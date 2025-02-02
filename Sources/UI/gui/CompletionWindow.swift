//
//  CompletionWindow.swift
//  AquaSKKUI
//
//  Created by mzp on 1/25/25.
//

import AppKit
import os

@objc public class CompletionWindow: NSObject {
    private static let sharedInstance = CompletionWindow()

    @objc(sharedWindow)
    public static func shared() -> CompletionWindow {
        sharedInstance
    }

    private let view: CompletionView
    private let window: NSWindow
    override public init() {
        view = CompletionView()

        window = .init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: true)
        window.backgroundColor = .clear
        window.isOpaque = false
        window.ignoresMouseEvents = true
        window.contentView = view
        super.init()
    }

    @objc public func showCompletion(_ completion: NSAttributedString, at topLeft: NSPoint, level: NSWindow.Level) {
        view.setCompletion(completion)

        var frame = view.frame
        frame.origin = topLeft
        frame.origin.y -= frame.size.height
        window.setFrame(frame, display: true)
        window.level = level
        window.orderFront(nil)
    }

    @objc public func hide() {
        guard Thread.isMainThread else {
            Logger.skkUI.fault("\(#function) must be called ifrom main therad only")
            assertionFailure("Must be used from main therad only")
            return
        }
        window.orderOut(nil)
    }
}
