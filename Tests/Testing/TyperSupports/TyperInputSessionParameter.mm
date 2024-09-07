//
//  TyperInputSessionParameter.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TyperInputSessionParameter.h"

#include <vector>

#import <AquaSKKInput/MacAnnotator.h>
#import <AquaSKKInput/MacCandidateWindow.h>
#import <AquaSKKInput/MacClipboard.h>
#import <AquaSKKInput/MacConfig.h>
#import <AquaSKKInput/MacDynamicCompletor.h>
#import <AquaSKKInput/MacFrontEnd.h>
#import <AquaSKKInput/MacMessenger.h>
#import <AquaSKKTesting/MockAnnotator.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockClipboard.h>
#import <AquaSKKTesting/MockDynamicCompletor.h>
#import <AquaSKKTesting/MockMessenger.h>

TyperInputSessionParameter::TyperInputSessionParameter(id client)
    : config_(new MacConfig()),
      frontend_(new MacFrontEnd(client)),
      messenger_(new MockMessenger()),
      clipboard_(new MockClipboard()),
      candidateWindow_(new MockCandidateWindow()),
      annotator_(new MockAnnotator()),
      completor_(new MockDynamicCompletor()) {}

SKKConfig *TyperInputSessionParameter::Config() {
    return config_.get();
}

SKKFrontEnd *TyperInputSessionParameter::FrontEnd() {
    return frontend_.get();
}

SKKMessenger *TyperInputSessionParameter::Messenger() {
    return messenger_.get();
}

SKKClipboard *TyperInputSessionParameter::Clipboard() {
    return clipboard_.get();
}

SKKCandidateWindow *TyperInputSessionParameter::CandidateWindow() {
    return candidateWindow_.get();
}

SKKAnnotator *TyperInputSessionParameter::Annotator() {
    return annotator_.get();
}

SKKDynamicCompletor *TyperInputSessionParameter::DynamicCompletor() {
    return completor_.get();
}

void TISRetain(TyperInputSessionParameter *params) {
    params->retain();
}

void TISRelease(TyperInputSessionParameter *params) {
    params->release();
}

TyperInputSessionParameter* TyperInputSessionParameter::make(id client) {
    return new TyperInputSessionParameter(client);
}

SKKInputSessionParameter *TyperInputSessionParameter::cast(TyperInputSessionParameter *params) {
    return params;
}

void TyperInputSessionParameter::SetString(std::string pasteString) {
    MockClipboard *clipboard = dynamic_cast<MockClipboard *>(this->Clipboard());
    clipboard->SetString(pasteString);
}

std::vector<std::string> TyperInputSessionParameter::Candidates() {
    MockCandidateWindow *candidateWindow =
    dynamic_cast<MockCandidateWindow *>(this->CandidateWindow());

    std::vector<std::string> result;

    auto container = candidateWindow->Container();
    std::for_each(container.begin(), container.end(), [&result](const SKKCandidate &candidate) {
        std::string variant = candidate.Variant();
        result.push_back(variant);
    });

    return result;
}
