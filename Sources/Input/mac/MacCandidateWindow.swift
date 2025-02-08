//
//  MacCandidateWindow.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import Foundation

@objc(MacCandidateWindowImpl)
public class MacCandidateWindowImpl: NSObject {
    let layoutManager: SKKLayoutManagerImpl

    @objc public init(layoutManager: SKKLayoutManagerImpl) {
        self.layoutManager = layoutManager
    }

    @objc public func setup() {}
}
