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
    let selector: SKKInputModeSelectorImpl

    @objc public init(context: SKKInputContext, param: SKKInputSessionParameterProtocol, selector: SKKInputModeSelectorImpl, isPrimaryEditor: Bool) {
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

    var candidateWindow: SKKCandidateWindowProtocol {
        param.candidateWindow()
    }

    var messenger: SKKMessengerProtocol {
        param.messenger()
    }

    var dynamicCompletor: SKKDynamicCompletorProtocol {
        param.dynamicCompletor()
    }
}
