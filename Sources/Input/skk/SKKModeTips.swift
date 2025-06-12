//
//  SKKModeTips.swift
//  AquaSKKInput
//
//  Created by mzp on 2/6/25.
//

import AppKit
import AquaSKKEngine
import AquaSKKUI
import CoreGraphics

@objc public class SKKModeTipsImpl: NSObject {
    private var timer: Timer? = nil
    private let layoutManager: SKKLayoutManager
    private let window: InputModeWindow

    public init(layoutManager: SKKLayoutManager) {
        self.layoutManager = layoutManager
        window = InputModeWindow.shared()
        super.init()
    }

    deinit {
        cancel()
    }

    @objc public func activate() {
        let point = layoutManager.inputOrigin()
        let cursor = flip(point: point)
        guard let pid = activeProcessID() else {
            return
        }
        let list = windowRects(ofProcess: pid)

        // カーソル位置がウィンドウ矩形に含まれていなければ無視する
        let found = list.contains(where: { $0.contains(cursor) })
        if !found {
            return
        }

        window.show(at: point, level: layoutManager.windowLevel())
    }

    public var inputMode: SKKInputMode {
        get {
            return window.inputMode
        }
        set {
            window.inputMode = newValue
        }
    }

    public func show() {
        cancel()

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(activate), userInfo: nil, repeats: false)
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
    }

    public func hide() {
        cancel()
        window.hide()
    }

    // MARK: MacInputModeWindow::Activate() から呼ばれるユーティリティ群

    /// 左下原点を左上原点に変換する
    private func flip(point: CGPoint) -> CGPoint {
        let frame = NSScreen.main?.frame ?? .zero
        return CGPoint(x: point.x, y: frame.height - point.y)
    }

    private func activeProcessID() -> pid_t? {
        return NSWorkspace.shared.frontmostApplication?.processIdentifier
    }

    /// プロセス ID に関連したウィンドウ矩形群の取得
    private func windowRects(ofProcess processID: pid_t) -> [CGRect] {
        var result = [CGRect]()
        let array = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID)

        for info in array as! [[CFString: Any]] {
            // 引数のプロセス ID でフィルタ
            if let owner = info[kCGWindowOwnerPID] as? Int,
               owner != processID
            {
                continue
            }

            // デスクトップ全面を覆う Finder のウィンドウは除外
            if let level = info[kCGWindowLayer] as? Int,
               level == CGWindowLevel.min
            {
                continue
            }

            if let bounds = info[kCGWindowBounds] as? NSDictionary,
               let rect = CGRect(dictionaryRepresentation: bounds)
            {
                result.append(rect)
            }
        }
        return result
    }
}
