//
//  CandidateView.swift
//  AquaSKKUI
//
//  Created by mzp on 1/27/25.
//

import AppKit

let kCellSpacing: CGFloat = 4.0

@objc(CandidateView) public class CandidateView: NSView {
    private var labels: String
    private var indicator: CandidatePageIndicator
    private var candidateCells: [CandidateCell]
    private var selected: Int
    private var font: NSFont?

    override public init(frame frameRect: NSRect) {
        labels = ""
        indicator = .init()
        candidateCells = []
        selected = 0
        font = nil
        super.init(frame: frameRect)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_: NSRect) {
        let margin = kCellSpacing
        var offset = NSPoint(x: margin, y: margin)
        let cellCount = CGFloat(labels.count)
        for (index, cell) in candidateCells.enumerated() {
            var maxSize = cell.size()
            maxSize.width = cell.defaultSize().width * cellCount + kCellSpacing * (cellCount - 1)

            let cellSize = cell.size()
            if cellSize.width < maxSize.width {
                cell.draw(at: offset, withFocus: selected == index)
            } else {
                cell.draw(at: offset, withSize: maxSize)
            }

            offset.x += cellSize.width + margin
        }
        let x = bounds.size.width - indicator.size().width - margin
        indicator.draw(at: .init(x: x, y: margin))
        NSColor.windowFrameTextColor.setStroke()
        frame.frame()
    }

    public func newCandidateCell() -> CandidateCell {
        .init(with: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize))
    }

    public var contentSize: CGSize {
        var result: NSSize = .zero
        let cell = newCandidateCell()
        let defaultSize = cell.defaultSize()
        result.width = (defaultSize.width + kCellSpacing) * CGFloat(labels.count)
        result.width += indicator.size().width
        result.height = defaultSize.height

        result.width += kCellSpacing * 2
        result.height += kCellSpacing * 2
        return result
    }

    // MARK: ObjC shim

    @objc public static func cellSpacing() -> CGFloat {
        return kCellSpacing
    }

    @objc(prepareWithFont:labels:) public func prepare(with font: NSFont, labels: String) {
        self.font = font
        self.labels = labels
    }

    @objc public func setCandidates(_ candidates: [String], selectedIndex cursor: Int) {
        candidateCells.removeAll()
        let labelArray = Array(labels.unicodeScalars)
        for (index, candidate) in candidates.enumerated() {
            let cell = newCandidateCell()
            let label = labelArray[index]
            cell.setString(candidate, withLabel: String(label.value))
            candidateCells.append(cell)
        }
        selected = cursor
        needsDisplay = true
    }

    @objc public func setPage(_ page: NSRange) {
        indicator.setPage(page)
        needsDisplay = true
    }
}
