//
//  SKKInputEnvironment.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/07.
//

import Foundation

@objc public class SKKInputEnvironmentImpl: NSObject {
    let context: SKKInputContext
    let isPrimaryEditor: Bool
    let param: SKKInputSessionParameterProtocol
    var selector: SKKInputModeSelector

    @objc public init(context: SKKInputContext, param: SKKInputSessionParameterProtocol, selector: SKKInputModeSelector, isPrimaryEditor: Bool) {
        self.context = context
        self.param = param
        self.selector = selector
        self.isPrimaryEditor = isPrimaryEditor
    }

    var config: SKKConfigProtocol {
        param.config()
    }

    var pasteString: String {
        param.clipboard().pasteString()
    }

    var annotator: SKKAnnotatorProtocol {
        param.annotator()
    }
}
