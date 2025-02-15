//
//  InputModeWindow.swift
//  AquaSKKUI
//
//  Created by mzp on 1/24/25.
//

import AppKit
import AquaSKKBackend
import os

@objc(InputModeWindow)
public class InputModeWindow: NSObject {
    private static let sharedInstance = InputModeWindow()
    @objc(sharedWindow)
    public static func shared() -> InputModeWindow {
        sharedInstance
    }

    private let window: NSWindow
    private let rootLayer: CALayer
    private let animaiton: CABasicAnimation

    // MARK: - Initialization

    override init() {
        window = .init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: true)
        window.backgroundColor = .clear
        window.isOpaque = false
        window.ignoresMouseEvents = true

        inputMode = .HirakanaInputMode
        modeIcons = [:]

        rootLayer = CALayer()
        animaiton = CABasicAnimation(keyPath: "opacity")

        super.init()

        prepareLayer()
        prepareAnimation()
    }

    private func prepareLayer() {
        rootLayer.opacity = 0
        guard let view = window.contentView else {
            Logger.skkUI.error("\(#function, privacy: .public) can't get content view")
            return
        }
        view.layer = rootLayer
        view.wantsLayer = true
    }

    private func prepareAnimation() {
        animaiton.duration = 2.0
        animaiton.fromValue = 1
        animaiton.toValue = 0
        animaiton.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.0, 0.5, 0.0)
    }

    // MARK: - Animation

    public var modeIcons: [SKKInputMode: NSImage]

    public var inputMode: SKKInputMode {
        didSet {
            updateFrame()
            updateImage()
        }
    }

    private func updateFrame() {
        guard Thread.isMainThread else {
            Logger.skkUI.fault("\(#function, privacy: .public) must be called ifrom main therad only")
            assertionFailure("Must be used from main therad only")
            return
        }

        var rect = window.frame
        var iconSize = rect.size
        if let icon = modeIcons[inputMode],
           !icon.representations.isEmpty
        {
            iconSize = icon.size
        }

        // ppc では、背景を clearColor にした NSWindow の矩形サイズが、いつ
        // のまにか 0*0 になってしまうことがある(QuarzDebug による調査)ため、
        // 表示する直前にウィンドウの矩形を設定し直す
        if rect.size != iconSize {
            // 画像サイズに応じて原点をオフセットする
            rect.origin.y += rect.size.height - iconSize.height
            rect.size = iconSize

            // 矩形設定時の画像ちらつきを防ぐ
            CATransaction.begin()
            CATransaction.setValue(0.0, forKey: kCATransactionAnimationDuration)
            rootLayer.contents = nil
            CATransaction.commit()

            window.setFrame(rect, display: true)
        }
    }

    private func updateImage() {
        let inputMode = self.inputMode
        guard let image = modeIcons[inputMode] else {
            Logger.skkUI.warning("\(#function, privacy: .public) no image for \(inputMode.rawValue)")
            return
        }
        guard let data = image.tiffRepresentation else {
            Logger.skkUI.error("\(#function, privacy: .public) no data for \(inputMode.rawValue)")
            return
        }
        let rep = NSBitmapImageRep(data: data)
        guard let cgImage = rep?.cgImage else {
            Logger.skkUI.error("\(#function, privacy: .public) no cgimage for \(inputMode.rawValue)")
            return
        }
        CATransaction.begin()
        CATransaction.setValue(0.0, forKey: kCATransactionAnimationDuration)
        rootLayer.contents = cgImage
        CATransaction.commit()
    }

    @objc public func show(at topLeft: NSPoint, level: NSWindow.Level) {
        updateFrame()
        window.setFrameTopLeftPoint(topLeft)
        window.level = level
        window.orderFront(nil)
        rootLayer.add(animaiton, forKey: "fadeOut")
    }

    @objc public func hide() {
        window.orderOut(nil)
    }

    // MARK: - Interface

    @objc public func setModeIcons(_ dictionary: NSDictionary) {
        var modeIcons = [SKKInputMode: NSImage]()
        for key in dictionary.allKeys {
            guard let inputMode = key as? SKKInputMode else {
                Logger.skkUI.fault("\(#function) unsupported key")
                continue
            }
            guard let value = dictionary[key],
                  let image = value as? NSImage
            else {
                Logger.skkUI.fault("\(#function) unsupported value")
                continue
            }
            modeIcons[inputMode] = image
        }
        self.modeIcons = modeIcons
    }

    @objc public func changeMode(_ mode: Int32) {
        guard let inputMode = SKKInputMode(rawValue: mode) else {
            Logger.skkUI.fault("\(#function, privacy: .public) unsupported mode \(mode, privacy: .public)")
            return
        }
        self.inputMode = inputMode
    }

    @objc public func currentInputMode() -> Int32 {
        inputMode.rawValue
    }
}
