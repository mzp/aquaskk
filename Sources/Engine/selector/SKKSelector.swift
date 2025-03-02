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
    private var buddy: SKKSelectorBuddy
    private var inlineSelector = SKKInlineSelectorImpl()
    private var windowSelector: SKKWindowSelectorImpl
    private var suite = SKKCandidateSuite()

    public init(buddy: SKKSelectorBuddy, presenter: SKKCandidateWindowPresenter) {
        self.buddy = buddy
        windowSelector = SKKWindowSelectorImpl(presenter: presenter)
    }

    public var isInline: Bool {
        return activeSelectorType == .inline
    }

    public func execute(inlineCount: Int) -> Bool {
        let entry = SKKSelectorBuddy.invokeSKKSelectorQueryEntry(buddy)
        suite.Clear()

        SKKBackendImpl.shared().find(entry: entry, to: &suite)

        inlineSelector.setup(container: Array(suite.candidates), inlineCount: inlineCount)
        windowSelector.setup(container: Array(suite.candidates), inlineCount: inlineCount)

        if !suite.IsEmpty() {
            if !inlineSelector.isEmpty {
                activeSelectorType = .inline
            } else {
                activeSelectorType = .window
            }
            notify()
        }

        return !suite.IsEmpty()
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
        if suite.IsEmpty() {
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
            SKKSelectorBuddy.invokeSKKSelectorUpdate(buddy, current)
        }
    }
}
