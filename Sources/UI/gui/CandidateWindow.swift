//
//  CandidateWindow.swift
//  AquaSKKUI
//
//  Created by mzp on 1/26/25.
//

import AppKit
import os

@objc(CandidateWindow)
public class CandidateWindow: NSObject {
    private static let sharedInstance = CandidateWindow()

    @objc(sharedWindow)
    public static func shared() -> CandidateWindow {
        return sharedInstance
    }

    private let view: CandidateView
    public private(set) var window: NSWindow
    private var labels: String
    override public init() {
        view = CandidateView(frame: .zero)
        window = .init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: true)
        window.ignoresMouseEvents = true
        window.contentView = view
        labels = ""
        super.init()
    }

    @objc(prepareWithFont:labels:)
    public func prepare(with font: NSFont, labels: NSString) {
        guard Thread.isMainThread else {
            Logger.skkUI.fault("\(#function) must be called ifrom main therad only")
            assertionFailure("Must be used from main therad only")
            return
        }
        self.labels = String(labels)
        view.prepare(with: font, labels: self.labels)
        window.setContentSize(view.contentSize)
    }

    @objc public func setCandidates(_ candidates: [String], selectedIndex: Int) {
        view.setCandidates(candidates, selectedIndex: selectedIndex)
    }

    @objc public func setPage(_ page: NSRange) {
        view.setPage(page)
    }

    @objc(showAt:level:)
    public func show(at origin: NSPoint, level: NSWindow.Level) {
        window.setFrameOrigin(origin)
        window.level = level
        window.orderFront(nil)
    }

    @objc public func hide() {
        window.orderOut(nil)
    }

    public func indexOf(label: Character) -> Int {
        guard let result = labels.range(of: String(label), options: .caseInsensitive) else {
            return -1
        }
        return result.lowerBound.utf16Offset(in: labels)
    }

    @objc public func newCandidateCell() -> CandidateCell {
        return view.newCandidateCell()
    }

    // MARK: - Shims

    @objc(window) public func windowObjc() -> NSWindow {
        return window
    }

    @objc public func indexOfLabel(_ label: UInt32) -> Int {
        indexOf(label: Character(UnicodeScalar(label)!))
    }
}
