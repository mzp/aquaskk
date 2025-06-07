//
//  TyperInputSessionParameter.swift
//  AquaSKKTesting
//
//  Created by mzp on 2025/06/06.
//

internal import AquaSKKEngine
import AquaSKKInput
import InputMethodKit

public class TyperInputSessionParameterImpl: AquaSKKEngine.SKKInputSessionParameterProtocol {
    private let annotatorImpl = MockAnnotatorImpl()
    private let dynamicCompletorImpl = MockDynamicCompletorImpl()
    private let configImpl: MockConfigImpl
    private let frontEndImpl: MacFrontEndImpl
    private let messengerImpl = NullMessengerImpl()
    private let clipboardImpl = MockClipboardImpl()
    private let candidateWindowImpl = MockCandidateWindowImpl()

    public init(config: MockConfigImpl, client: IMKTextInput) {
        configImpl = config
        frontEndImpl = MacFrontEndImpl(client: client)
    }

    public func config() -> any AquaSKKEngine.SKKConfigProtocol {
        return configImpl
    }

    public func frontEnd() -> any AquaSKKEngine.SKKFrontEndProtocol {
        return frontEndImpl
    }

    public func messenger() -> any AquaSKKEngine.SKKMessengerProtocol {
        return messengerImpl
    }

    public func clipboard() -> any AquaSKKEngine.SKKClipboardProtocol {
        return clipboardImpl
    }

    public func candidateWindow() -> any AquaSKKEngine.SKKCandidateWindowProtocol {
        return candidateWindowImpl
    }

    public func annotator() -> any AquaSKKEngine.SKKAnnotatorProtocol {
        return annotatorImpl
    }

    public func dynamicCompletor() -> any AquaSKKEngine.SKKDynamicCompletorProtocol {
        return dynamicCompletorImpl
    }

    // MARK: - helper

    public func setYankString(_ string: String) {
        clipboardImpl.string = string
    }

    public var candidates: [String] {
        candidateWindowImpl.candidates
    }

    public var candidateCursor: Int {
        candidateWindowImpl.cursor
    }

    public var candidatePage: Int {
        candidateWindowImpl.position
    }

    public var completion: String {
        dynamicCompletorImpl.completion
    }

    public var commonPrefixLength: Int {
        dynamicCompletorImpl.commonPrefixLength
    }

    public var cursorOffset: Int {
        dynamicCompletorImpl.cursorOffset
    }

    public var completionVisible: Bool {
        dynamicCompletorImpl.visible
    }

    public var annotation: String {
        annotatorImpl.candidate ?? ""
    }

    public var annotationCursor: Int {
        annotatorImpl.cursorOffset
    }

    public var annotationVisible: Bool {
        annotatorImpl.visible
    }
}
