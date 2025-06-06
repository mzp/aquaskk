//
//  MockInputSessionParameter.swift
//  AquaSKKTesting
//
//  Created by mzp on 2025/06/06.
//

internal import AquaSKKEngine

@objc public class MockInputSessionParameterImpl: NSObject, SKKInputSessionParameterProtocol {
    private let annotatorImpl = MockAnnotatorImpl()
    private let dynamicCompletorImpl = MockDynamicCompletorImpl()
    private let configImpl = NullConfigImpl()
    private let frontEndImpl = MockFrontEndImpl()
    private let messengerImpl = NullMessengerImpl()
    private let clipboardImpl = MockClipboardImpl()
    private let candidateWindowImpl = MockCandidateWindowImpl()

    @objc override public init() {}

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

    @objc public func listener() -> SKKInputModeListenerProtocol {
        return frontEndImpl
    }

    @objc public func resultFixed() -> String {
        return frontEndImpl.fixed
    }

    @objc public func resultMarked() -> String {
        return frontEndImpl.marked
    }

    @objc public func resultPos() -> Int {
        return frontEndImpl.pos
    }

    @objc public func resultMode() -> SKKInputMode {
        return frontEndImpl.mode
    }

    @objc public func setSelectedString(_ string: String) {
        frontEndImpl.setSelectedString(string)
    }

    @objc public func setYankString(_ string: String) {
        clipboardImpl.string = string
    }
}
