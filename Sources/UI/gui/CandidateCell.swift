//
//  CandidateCell.swift
//  AquaSKKUI
//
//  Created by mzp on 2/1/25.
//
import AppKit

private let kMargin: CGFloat = 2.0

@objc(CandidateCell)
public class CandidateCell: NSObject {
    private var entry: NSMutableAttributedString
    private var attributes: [NSAttributedString.Key: Any]
    private var focusSize: CGSize

    static func focusSize(_ size: CGSize) -> CGSize {
        return .init(
            width: size.width + kMargin * 2,
            height: size.height + kMargin * 2
        )
    }

    @objc(initWithFont:)
    public init(with font: NSFont) {
        let entry = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.labelColor,
        ]
        let tmpStr = NSAttributedString(string: " A  漢字 ", attributes: attributes)
        let size = Self.focusSize(tmpStr.size())

        self.entry = entry
        self.attributes = attributes
        focusSize = size
        super.init()
    }

    @objc(setString:withLabel:)
    public func setString(_ string: String, withLabel label: String) {
        let tmp = NSAttributedString(string: " \(label)  \(string)", attributes: attributes)
        entry.setAttributedString(tmp)

        // ラベルの背景色
        entry.addAttribute(.backgroundColor, value: NSColor.controlAccentColor, range: NSRange(location: 0, length: 3))

        // ラベルの文字色
        entry.addAttribute(.foregroundColor, value: NSColor.selectedMenuItemTextColor, range: NSRange(location: 0, length: 3))

        let style: NSMutableParagraphStyle = NSParagraphStyle.skk_mutableDefault()
        style.lineBreakMode = .byTruncatingTail
        entry.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: entry.length))
    }

    @objc(drawAtPoint:withSize:)
    public func draw(at point: NSPoint, withSize size: CGSize) {
        var focus = CGRect(origin: point, size: size)
        focus.size.height -= 1

        guard let context = NSGraphicsContext.current else {
            return
        }
        context.shouldAntialias = false
        defer {
            context.shouldAntialias = true
        }

        NSColor.windowBackgroundColor.withSystemEffect(.pressed).setFill()
        focus.fill(using: .sourceOver)
        NSColor.windowFrameTextColor.setStroke()
        NSBezierPath.stroke(focus)
    }

    @objc(drawAtPoint:withFocus:)
    public func draw(at point: NSPoint, withFocus focus: Bool) {
        if focus {
            draw(at: point, withSize: size())
        }
        let rect = NSRect(
            origin: NSPoint(x: point.x + kMargin, y: point.y + kMargin),
            size: entry.size()
        )
        entry.draw(in: rect)
    }

    @objc public func size() -> CGSize {
        let current = Self.focusSize(entry.size())

        if current.width < defaultSize().width {
            return defaultSize()
        } else {
            return current
        }
    }

    @objc public func defaultSize() -> CGSize {
        return focusSize
    }
}
