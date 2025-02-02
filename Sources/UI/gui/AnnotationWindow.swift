//
//  AnnotationWindow.swift
//  AquaSKKUI
//
//  Created by mzp on 2/1/25.
//

import AppKit

@objc(AnnotationWindow) public class AnnotationWindow: NSObject {
    private static let sharedInstance = AnnotationWindow()
    @objc(sharedWindow)
    public static func shared() -> AnnotationWindow {
        return sharedInstance
    }

    private let view: AnnotationView
    private let window: NSWindow

    override init() {
        view = .init()

        window = .init(contentRect: view.frame, styleMask: .borderless, backing: .buffered, defer: true)
        window.contentView = view
        super.init()
    }

    @objc(window) public func getWindow() -> NSWindow {
        return window
    }

    @objc(setAnnotation:optional:) public func setAnnotation(_ definition: String, optional: String) {
        view.setAnnotation(definition, optional: optional)
    }

    private func activate() {
        window.orderFront(nil)
        view.needsDisplay = true
    }

    @objc public func hide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        window.orderOut(nil)
    }

    @objc(showAt:level:) public func show(at origin: NSPoint, level: NSWindow.Level) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        guard view.hasAnnotation() else {
            hide()
            return
        }

        window.setFrameOrigin(origin)
        window.level = level
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) { [weak self] in
            self?.activate()
        }
    }
}
