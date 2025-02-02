//
//  MessengerView.swift
//  AquaSKKUI
//
//  Created by mzp on 1/20/25.
//

import AppKit

@objc(MessengerView)
public class MessengerView: NSView {
    private let attributes: [NSAttributedString.Key: Any]
    private let icon: NSImage
    private var content: String

    public init() {
        icon = NSImage(named: NSImage.infoName)!
        icon.size = .init(width: 16, height: 16)

        attributes = [
            .font: NSFont.systemFont(ofSize: 0.0),
        ]

        content = ""

        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var messeage: String {
        get { return "" }
        set {
            content = newValue
            frame = messageRect
            needsDisplay = true
        }
    }

    @objc(setMessage:)
    public func setMessage(_ value: String) {
        messeage = value
    }

    override public func draw(_: CGRect) {
        let frame = messageRect
        NSColor.controlColor.setFill()
        NSColor.separatorColor.setStroke()

        frame.fill()
        NSBezierPath.stroke(frame)

        let point = NSPoint(x: 3, y: (frame.height - icon.size.height) / 2)
        icon.draw(at: point, from: .zero, operation: .sourceOver, fraction: 1.0)
        content.draw(at: .init(x: point.x + icon.size.width + 2, y: 4), withAttributes: attributes)
    }

    private var messageRect: NSRect {
        var size = (content as NSString).size(withAttributes: attributes)
        size.height += 8
        size.width += icon.size.width + 8

        return .init(origin: .zero, size: size)
    }
}
