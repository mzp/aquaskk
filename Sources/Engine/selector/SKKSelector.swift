//
//  SKKSelector.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/01.
//

import AquaSKKBackend

class SKKSelectorImpl {
    enum SelectorType {
        case inline
        case window
    }
    private var activeSelectorType: SelectorType = .inline
    private var buddy: SKKSelectorBuddy
    private var inlineSelector = SKKInlineSelectorImpl()
    private var windowSelector: SKKWindowSelectorImpl
    private var suite = SKKCandidateSuite()

    init(buddy: SKKSelectorBuddy, window: CandidateWindowPresenter) {
        self.buddy = buddy
        self.windowSelector = SKKWindowSelectorImpl(presenter: window)
    }

    var isInline: Bool {
        return activeSelectorType == .inline
    }

    func execute(inlineCount: Int) -> Bool {
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

    func next() -> Bool {
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

    func prev() -> Bool {
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

    func cursorLeft() {
        if activeSelectorType == .window {
            windowSelector.cursorLeft()
        }
        notify()
    }

    func cursorRight() {
        if activeSelectorType == .window {
            windowSelector.cursorRight()
        }
        notify()
    }

    func cursorUp() {
        if activeSelectorType == .window {
            windowSelector.cursorUp()
        }
        notify()
    }

    func cursorDown() {
        if activeSelectorType == .window {
            windowSelector.cursorDown()
        }
        notify()
    }

    func select(label: Character) -> Bool {
        if isInline {
            return false
        }

        if windowSelector.select(label: label) {
            notify()
            return true
        }

        return false
    }

    func show() {
        if isInline {
            return
        }

        windowSelector.show()
    }

    func hide() {
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
