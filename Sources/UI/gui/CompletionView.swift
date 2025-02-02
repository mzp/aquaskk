//
//  CompletionView.swift
//  AquaSKKUI
//
//  Created by mzp on 1/25/25.
//

import AppKit

private let strokeColor = NSColor.separatorColor
private let backgroundColor = NSColor(deviceRed: 1, green: 1, blue: 0.94, alpha: 1.0)

func newGuide(string: String) -> NSAttributedString {
    return NSMutableAttributedString(string: string, attributes: [
        .font: NSFont.boldSystemFont(ofSize: NSFont.labelFontSize),
        .foregroundColor: NSColor.white,
        .backgroundColor: strokeColor,
    ])
}

@objc(CompletionView)
public class CompletionView: NSView {
    var completion: NSAttributedString
    let guide: NSAttributedString
    let guideSize: CGSize

    public init() {
        completion = .init()
        guide = NSMutableAttributedString(string: "  TAB で補完  ", attributes: [
            .font: NSFont.boldSystemFont(ofSize: NSFont.labelFontSize),
            .foregroundColor: NSColor.white,
            .backgroundColor: strokeColor,
        ])
        var guideSize = guide.size()
        guideSize.height += 2
        self.guideSize = guideSize
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var completionRect: NSRect {
        var size = completion.size()
        size.width = max(size.width, guideSize.width)
        size.width += 8
        size.height += guideSize.height + 8
        return .init(origin: .zero, size: size)
    }

    public func setCompletion(_ completion: NSAttributedString) {
        self.completion = completion
        frame = completionRect
        needsDisplay = true
    }

    override public func draw(_: NSRect) {
        var frame = self.frame
        frame.origin.y += guideSize.height
        frame.size.height -= guideSize.height

        backgroundColor.setFill()
        frame.fill()

        strokeColor.set()
        frame.frame()

        frame.origin.y = 0
        frame.size.height = guideSize.height

        let guidePlate = NSBezierPath(roundedRect: frame, xRadius: frame.height / 2, yRadius: frame.height / 2)
        frame.origin.y = guideSize.height / 2
        frame.size.height = guideSize.height / 2
        guidePlate.appendRect(frame)
        guidePlate.fill()

        let pt = NSPoint(x: (frame.width - guideSize.width) / 2, y: 1)
        guide.draw(at: pt)
        completion.draw(at: .init(x: 3, y: guideSize.height + 4))
    }
}
