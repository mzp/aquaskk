//
//  SKKSelector.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/01.
//

import AquaSKKBackend

public class SKKSelectorImpl {
    enum SelectorType {
        case inline
        case window
    }

    private var activeSelectorType: SelectorType = .inline
    private var buddy: SKKSelectorBuddyProtocol
    private var inlineSelector = SKKInlineSelectorImpl()
    private var windowSelector: SKKWindowSelectorImpl
    private var suite = SKKCandidateSuite()

    // FIXME: Xcode 16.2
    public static func createBridge(buddy: SKKSelectorBuddy, window: SKKCandidateWindowBridge) -> SKKSelectorImpl {
        .init(buddy: buddy.getSelectorBuddyProtocol(), presenter: SKKCandidateWindowBridgeAdapter(window))
    }

    public init(buddy: SKKSelectorBuddyProtocol, presenter: SKKCandidatePresenter) {
        self.buddy = buddy
        windowSelector = SKKWindowSelectorImpl(presenter: presenter)
    }

    deinit {}

    public var isInline: Bool {
        return activeSelectorType == .inline
    }

    public func execute(inlineCount: Int) -> Bool {
        let array = buddy.bridgeSelectorQueryEntry()
        let entry = SKKEntry(std.string(array[0]), std.string(array[1]))
        suite.clear()

        SKKBackendImpl.shared().find(entry: entry, to: &suite)

        inlineSelector.setup(container: Array(suite.candidates), inlineCount: inlineCount)
        windowSelector.setup(container: Array(suite.candidates), inlineCount: inlineCount)

        if !suite.isEmpty {
            if !inlineSelector.isEmpty {
                activeSelectorType = .inline
            } else {
                activeSelectorType = .window
            }
            notify()
        }

        return !suite.isEmpty
    }

    public func next() -> Bool {
        let result = activeSelectorType == .inline ? inlineSelector.next() : windowSelector.next()
        if !result {
            if !isInline || windowSelector.isEmpty {
                return false
            }
            activeSelectorType = .window
            windowSelector.show()
        }

        notify()
        return true
    }

    public func prev() -> Bool {
        let result = activeSelectorType == .inline ? inlineSelector.prev() : windowSelector.prev()
        if !result {
            if isInline || inlineSelector.isEmpty {
                return false
            }
            activeSelectorType = .inline
            windowSelector.hide()
        }

        notify()
        return true
    }

    public func cursorLeft() {
        if activeSelectorType == .window {
            windowSelector.cursorLeft()
        }
        notify()
    }

    public func cursorRight() {
        if activeSelectorType == .window {
            windowSelector.cursorRight()
        }
        notify()
    }

    public func cursorUp() {
        if activeSelectorType == .window {
            windowSelector.cursorUp()
        }
        notify()
    }

    public func cursorDown() {
        if activeSelectorType == .window {
            windowSelector.cursorDown()
        }
        notify()
    }

    public func select(label: Int) -> Bool {
        if isInline {
            return false
        }

        if windowSelector.select(label: label) {
            notify()
            return true
        }

        return false
    }

    public func show() {
        if isInline {
            return
        }

        windowSelector.show()
    }

    public func hide() {
        if isInline {
            return
        }

        windowSelector.hide()
    }

    private func notify() {
        if suite.isEmpty {
            return
        }

        let current: SKKCandidate?
        switch activeSelectorType {
        case .inline:
            current = inlineSelector.current
        case .window:
            current = windowSelector.current
        }
        if let current = current {
            buddy.bridgeSelectorUpdate(candidate: String(current.ToString()))
        }
    }
}
