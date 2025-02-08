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
}
