//
//  SKKLayoutManager.swift
//  AquaSKKInput
//
//  Created by mzp on 2/2/25.
//
// import AppKit
import AquaSKKUI
import InputMethodKit
import os

private let kMargin: CGFloat = 1.0

@objc public class SKKLayoutManagerImpl: NSObject {
    var client: IMKTextInput
    @objc public init(client: IMKTextInput) {
        self.client = client
    }

    @MainActor public func inputOrigin() -> CGPoint {
        return inputOrigin(index: 0)
    }

    @MainActor @objc public func inputOrigin(index: Int) -> CGPoint {
        let frame = inputFrame(at: index)
        return frame.origin
    }

    @MainActor @objc public func candidateWindowOrigin() -> CGPoint {
        let input = inputFrame(at: 0)
        var candidate = CandidateWindow.shared().window.frame
        let screen = screenFrame(input: input)
        candidate.origin = input.origin
        let candidateIsUpward = UserDefaults.standard.bool(forKey: SKKUserDefaultKeys.put_candidate_window_upward)

        // 右端
        var point = fit(screen: screen, window: candidate)

        if candidateIsUpward {
            point.y = input.maxY + kMargin

            // 上端
            if screen.height < point.y + candidate.height {
                point.y = input.minY - candidate.height - kMargin
            }
        } else {
            point.y -= candidate.height + kMargin

            // 下端
            if point.y < screen.minY {
                point.y = input.maxY + kMargin
            }
        }

        return point
    }

    @MainActor @objc public func annotationWindowOrigin(mark: Int) -> CGPoint {
        let input = inputFrame(at: mark)
        let annotation = AnnotationWindow.shared().window.frame
        let screen = screenFrame(input: input)
        let candidateWindow = CandidateWindow.shared().window
        let candidate = candidateWindow.frame
        let candidateIsVisible = candidateWindow.isVisible
        let candidateIsUpward = input.origin.y < candidate.origin.y

        // 右端
        var point = fit(screen: screen, window: annotation)

        // アノテーションは常に下に表示する
        point.y -= annotation.height + kMargin
        if candidateIsVisible && !candidateIsUpward {
            point.y -= candidate.height + kMargin
        }

        // 下端
        if !screen.contains(point) {
            point.y = input.maxY + kMargin
            if candidateIsVisible && candidateIsUpward {
                point.y += candidate.height + kMargin
            }
        }

        return point
    }

    @objc public func windowLevel() -> NSWindow.Level {
        return NSWindow.Level(Int(client.windowLevel()) + 1)
    }

    @MainActor func inputFrame(at index: Int) -> CGRect {
        var frame = CGRect.zero

        let candidate = CandidateWindow.shared().window.frame
        let dict = client.attributes(forCharacterIndex: index, lineHeightRectangle: &frame)

        if let dict = dict as? NSDictionary {
            let height: CGFloat
            if let font = dict[NSAttributedString.Key.font] as? NSFont {
                height = font.boundingRectForFont.height
            } else {
                height = candidate.height
            }
            frame.size.height = height
        }
        return frame
    }

    private func screenFrame(input: CGRect) -> CGRect {
        for screen in NSScreen.screens {
            let whole = screen.frame
            var frame = screen.visibleFrame

            frame.origin = whole.origin
            frame.size.width = whole.width

            if frame.contains(input) {
                return frame
            }
        }

        // 念の為
        return NSScreen.main?.frame ?? .zero
    }

    private func fit(screen: CGRect, window: CGRect) -> CGPoint {
        var point = window.origin

        if screen.maxX < window.maxX {
            point.x = screen.maxX - window.width
        }
        return point
    }
}
