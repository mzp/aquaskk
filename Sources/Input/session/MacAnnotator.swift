//
//  MacAnnotator.swift
//  AquaSKKInput
//
//  Created by mzp on 2/2/25.
//
import AquaSKKEngine
import AquaSKKUI

@objc(MacAnnotatorImpl)
public class MacAnnotatorImpl: NSObject, SKKAnnotatorProtocol {
    private let window: AnnotationWindow
    private let layoutManager: SKKLayoutManager

    private var definition: String
    private var optional: String
    private var candidate: SKKCandidate?
    private var cursorOffset: Int

    @objc public init(layoutManager: SKKLayoutManager) {
        window = AnnotationWindow.shared()
        self.layoutManager = layoutManager

        definition = ""
        optional = ""
        candidate = nil
        cursorOffset = 0
    }

    @objc(update:cursorOffset:)
    public func update(candidateBridge bridge: SKKCandidateBridge, cursorOffset: Int) {
        update(candidate: bridge.rawValue.pointee, cursorOffset: cursorOffset)
    }

    public func update(candidate: SKKCandidate, cursorOffset: Int) {
        self.candidate = candidate
        self.cursorOffset = cursorOffset
        let string = String(candidate.getVariant())

        let value = DCSCopyTextDefinition(nil, string as CFString, .init(location: 0, length: string.count))?.takeRetainedValue()

        definition = (value as String?) ?? ""
        optional = String(candidate.getAnnotation())
    }

    @objc public func skkWidgetShow() {
        window.setAnnotation(definition, optional: optional)

        if definition.isEmpty, optional.isEmpty {
            skkWidgetHide()
        }
        window.show(at: layoutManager.annotationWindowOrigin(mark: cursorOffset), level: layoutManager.windowLevel())
    }

    @objc public func skkWidgetHide() {
        window.hide()
    }
}
