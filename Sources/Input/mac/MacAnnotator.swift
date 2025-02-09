//
//  MacAnnotator.swift
//  AquaSKKInput
//
//  Created by mzp on 2/2/25.
//

import Foundation

@objc(MacAnnotatorImpl)
public class MacAnnotatorImpl: NSObject {
    let window: AnnotationWindow
    let layoutManager: SKKLayoutManagerImpl

    var definition: String
    var optional: String
    var candidate: SKKCandidate?
    var cursorOffset: Int

    @objc public init(layoutManager: SKKLayoutManagerImpl) {
        window = AnnotationWindow.shared()
        self.layoutManager = layoutManager

        definition = ""
        optional = ""
        candidate = nil
        cursorOffset = 0
    }

    @objc(update:cursorOffset:) public func updateObjc(candidate: SKKCandidateBridge, cursorOffset: Int) {
//        update(candidate: candidate.rawValue.pointee, cursorOffset: cursorOffset)
    }

    @MainActor public func update(candidate: SKKCandidate, cursorOffset: Int) {
        self.candidate = candidate
        self.cursorOffset = cursorOffset
        let string = String(candidate.getVariant())

        let value = DCSCopyTextDefinition(nil, string as CFString, .init(location: 0, length: string.count))?.takeRetainedValue()

        self.definition = (value as String?) ?? ""
        optional = String(candidate.getAnnotation())
    }

    @objc(skkWidgetShow) public func skkWidgetShow() {
    }

    @MainActor public func activate() {
        window.setAnnotation(definition, optional: optional)

        if definition.isEmpty, optional.isEmpty {
            skkWidgetHide()
        }
        window.show(at: layoutManager.annotationWindowOrigin(mark: cursorOffset), level: layoutManager.windowLevel())
    }

    @MainActor public func deactivate() {
        window.hide()
    }

    @objc public func skkWidgetHide() {

    }
}
