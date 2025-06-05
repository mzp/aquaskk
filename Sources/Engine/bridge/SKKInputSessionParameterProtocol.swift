//
//  SKKInputSessionParameterProtocol.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/05/24.
//

@objc public protocol SKKInputSessionParameterProtocol {
    func config() -> SKKConfigProtocol
    func frontEnd() -> SKKFrontEndProtocol
    func messenger() -> SKKMessengerProtocol
    func clipboard() -> SKKClipboardProtocol
    func candidateWindow() -> SKKCandidateWindowProtocol
    func annotator() -> SKKAnnotatorProtocol
    func dynamicCompletor() -> SKKDynamicCompletorProtocol
}
