//
//  MacInputSessionParameter.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/05/24.
//

import AquaSKKEngine
import Foundation
import InputMethodKit

@objc public class MacInputSessionParameterImpl: NSObject, SKKInputSessionParameterProtocol {
    private let annotatorImpl: MacAnnotatorImpl
    private let candidateWindowImpl: MacCandidateWindowImpl
    private let configImpl: MacConfigImpl
    private let clipboardImpl: MacClipboardImpl
    private let completorImpl: MacDynamicCompletorImpl
    private let frontendImpl: MacFrontEndImpl
    private let messengerImpl: MacMessengerImpl

    @objc public init(client: IMKTextInput, layoutManager: SKKLayoutManager) {
        annotatorImpl = .init(layoutManager: layoutManager)
        candidateWindowImpl = .init(layoutManager: layoutManager)
        configImpl = .init()
        clipboardImpl = .init()
        completorImpl = .init(layoutManager: layoutManager)
        frontendImpl = .init(client: client)
        messengerImpl = .init(layoutManager: layoutManager)
    }

    public func config() -> any AquaSKKEngine.SKKConfigProtocol {
        configImpl
    }

    public func frontEnd() -> any AquaSKKEngine.SKKFrontEndProtocol {
        frontendImpl
    }

    public func messenger() -> any AquaSKKEngine.SKKMessengerProtocol {
        messengerImpl
    }

    public func clipboard() -> any AquaSKKEngine.SKKClipboardProtocol {
        clipboardImpl
    }

    public func candidateWindow() -> any AquaSKKEngine.SKKCandidateWindowProtocol {
        candidateWindowImpl
    }

    public func annotator() -> any AquaSKKEngine.SKKAnnotatorProtocol {
        annotatorImpl
    }

    public func dynamicCompletor() -> any AquaSKKEngine.SKKDynamicCompletorProtocol {
        completorImpl
    }
}
