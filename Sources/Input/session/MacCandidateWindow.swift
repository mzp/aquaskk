//
//  MacCandidateWindow.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import AppKit
import AquaSKKEngine
import AquaSKKService
import AquaSKKUI
import OSLog

@objc(MacCandidateWindowImpl)
public class MacCandidateWindowImpl: SKKWidgetBase, SKKCandidateWindowProtocol {
    let layoutManager: SKKLayoutManager
    let window: CandidateWindow
    var candidates: [String]
    var cursorIndex: Int
    var cellCount: Int
    var putUpward: Bool
    var page: NSRange

    @objc public init(layoutManager: SKKLayoutManager) {
        self.layoutManager = layoutManager
        window = .shared()
        candidates = []
        cursorIndex = 0
        cellCount = 0
        putUpward = false
        page = .init()
        super.init()
        reloadUserDefaults()
    }

    @objc public func setup(candidates: [String]) -> [Int] {
        reloadUserDefaults()
        let cell = window.newCandidateCell()
        var cellWidths: [CGFloat] = []

        for candidate in candidates {
            let width: CGFloat
            if candidate.count < 3 {
                width = cell.defaultSize().width
            } else {
                cell.setString(candidate, withLabel: "A")
                width = cell.size().width
            }
            cellWidths.append(width + CGFloat(CandidateView.cellSpacing()))
        }
        let limit = (cell.defaultSize().width + CandidateView.cellSpacing()) * CGFloat(cellCount)
        var offset = 0

        // 候補ウィンドウに表示可能な cell の数を求める
        var pages: [Int] = []
        repeat {
            var size: CGFloat = 0
            var count = 0
            while offset < cellWidths.count {
                if limit < size + cellWidths[offset] {
                    if size == 0 {
                        offset += 1
                        count = 1
                    }
                    break
                }
                size += cellWidths[offset]
                offset += 1
                count += 1
            }
            pages.append(count)
        } while offset < cellWidths.count

        return pages
    }

    @objc public func update(candidates: [String], cursor: Int, position: Int, max: Int) {
        self.candidates = candidates
        page = .init(location: position, length: max)
        cursorIndex = cursor
    }

    @objc public func labelIndex(of label: Int) -> Int {
        return window.indexOf(label: Character(UnicodeScalar(label)!))
    }

    func reloadUserDefaults() {
        let defaults = UserDefaults.standard
        var font: NSFont? = nil
        let fontName = defaults.string(forKey: SKKUserDefaultKeys.candidate_window_font_name)
        let fontSize = defaults.float(forKey: SKKUserDefaultKeys.candidate_window_font_size)
        if let fontName = fontName {
            font = NSFont(name: fontName, size: CGFloat(fontSize))
        }
        if font == nil {
            font = NSFont.labelFont(ofSize: CGFloat(fontSize))
        }
        guard let font = font else {
            Logger.skkInput.warning("Failed to create NSFont.")
            return
        }
        let labels = defaults.string(forKey: SKKUserDefaultKeys.candidate_window_labels) ?? ""
        cellCount = labels.count
        putUpward = defaults.bool(forKey: SKKUserDefaultKeys.put_candidate_window_upward)
        window.prepare(with: font, labels: labels as NSString)
    }

    @objc override public func skkWidgetShow() {
        window.setCandidates(candidates, selectedIndex: cursorIndex)
        window.setPage(page)
        window.show(at: layoutManager.candidateWindowOrigin(), level: layoutManager.windowLevel())
    }

    @objc override public func skkWidgetHide() {
        window.hide()
    }
}
