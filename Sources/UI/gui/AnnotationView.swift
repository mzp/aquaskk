//
//  AnnotationView.swift
//  AquaSKKUI
//
//  Created by mzp on 1/20/25.
//

import AppKit

@objc(AnnotationView)
public class AnnotationView: NSView {
    var textView: NSTextView? = nil
    private let strokeColor: NSColor
    private let definitiveHeader: NSAttributedString
    private let annotationHeader: NSAttributedString

    public init() {
        strokeColor = .windowFrameTextColor
        definitiveHeader = Self.newHeader("意味・語源")
        annotationHeader = Self.newHeader("SKK 辞書の註釈")

        super.init(frame: .init(origin: .zero, size: .init(width: 256, height: 128)))
        prepareView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Initialization

    let blockStyle: NSParagraphStyle = {
        let margin = NSFont.systemFontSize
        let style = NSParagraphStyle.skk_mutableDefault()
        style.firstLineHeadIndent = margin
        style.headIndent = margin
        return style
    }()

    let listStyle: NSParagraphStyle = {
        let margin = NSFont.systemFontSize
        let tabStop = margin * 2.5
        let style = NSParagraphStyle.skk_mutableDefault()
        style.firstLineHeadIndent = margin
        style.headIndent = tabStop
        style.tabStops = []
        style.defaultTabInterval = tabStop
        return style
    }()

    func prepareView() {
        var frame = self.frame
        frame.origin = .init(x: 1, y: 1)
        frame.size.width -= 2
        frame.size.height -= 2

        let scrollView = NSScrollView(frame: frame)
        scrollView.hasVerticalScroller = true
        scrollView.verticalScroller?.controlSize = .small

        let textView = NSTextView(frame: scrollView.contentView.frame)
        textView.isEditable = false
        textView.backgroundColor = .init(deviceRed: 1, green: 1, blue: 0.94, alpha: 1.0)
        textView.textContainerInset = .init(width: 0, height: 2)
        scrollView.documentView = textView
        addSubview(scrollView)

        self.textView = textView
    }

    static func newHeader(_ string: String) -> NSAttributedString {
        let style = NSParagraphStyle.skk_mutableDefault()
        style.lineSpacing = 4.0

        return NSAttributedString(string: string, attributes: [
            .font: NSFont.boldSystemFont(ofSize: NSFont.labelFontSize),
            .foregroundColor: NSColor.gray,
            .paragraphStyle: style,
        ])
    }

    // MARK: NSView overrides

    override public func draw(_: NSRect) {
        strokeColor.set()
        frame.frame()
    }

    // MARK: -

    @objc(setAnnotation:optional:)
    public func setAnnotation(_ definition: String?, optional annotation: String?) {
        guard let textView = textView else {
            return
        }
        textView.string = ""
        guard let storage = textView.textStorage else {
            return
        }
        storage.beginEditing()

        if let definition = definition {
            storage.append(definitiveHeader)
            setDefinitiveAnnotation(definition)
        }
        if let annotation = annotation {
            if definition != nil {
                appendNewLine()
            }
            storage.append(annotationHeader)
            setOptionalAnnotation(annotation)
        }

        storage.endEditing()

        scrollToTop()
    }

    private func setDefinitiveAnnotation(_ string: String) {
        guard let storage = textView?.textStorage else {
            return
        }

        let lines = string.split(separator: "\n")
        var i = 0
        while i < lines.count {
            let line = lines[i]
            if line.isEmpty {
                i += 1
                continue
            }
            appendNewLine()

            if line.count == 1 && i + 1 < lines.count {
                let item = "\(lines[i])\t\(lines[i + 1])"
                let attr = Self.attributedString(Self.normalize(string: item), style: listStyle)
                storage.append(attr)
                i += 1
            } else {
                let attr = Self.attributedString(Self.normalize(string: line), style: blockStyle)
                storage.append(attr)
            }
            i += 1
        }
    }

    private func setOptionalAnnotation(_ string: String) {
        guard let storage = textView?.textStorage else {
            return
        }
        appendNewLine()
        storage.append(Self.attributedString(string, style: blockStyle))
    }

    private func appendNewLine() {
        textView?.textStorage?.mutableString.append("\n")
    }

    private func scrollToTop() {
        guard let textView = textView else {
            return
        }
        let top: NSPoint
        if textView.isFlipped {
            top = .zero
        } else {
            top = .init(x: 0, y: textView.frame.maxY - textView.bounds.height)
        }
        textView.scroll(top)
    }

    @objc public func hasAnnotation() -> Bool {
        guard let textView = textView else {
            return false
        }
        return !textView.string.isEmpty
    }

    static func normalize(string: any StringProtocol) -> String {
        let table = [
            (0xE021, "[ー]"),
            (0xE022, "[二]"),
            (0xE023, "[三]"),
            (0xE024, "[四]"),
            (0xE025, "[五]"),
            (0xE026, "[六]"),
            (0xE027, "[文]"),
        ]

        var result = String(string)
        for (unichar, string) in table {
            let from = String(UnicodeScalar(unichar)!)
            result = result.replacingOccurrences(of: from, with: string)
        }

        return result
    }

    static func attributedString(_ string: String, style: NSParagraphStyle) -> NSAttributedString {
        NSAttributedString(
            string: string,
            attributes: [.paragraphStyle: style]
        )
    }
}
