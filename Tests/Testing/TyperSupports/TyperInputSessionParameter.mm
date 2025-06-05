//
//  TyperInputSessionParameter.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TyperInputSessionParameter.h"
#include <vector>
#import <AquaSKKEngine/AquaSKKEngine.h>
#import <AquaSKKInput/AquaSKKInput.h>
#import <AquaSKKTesting/MockAnnotator.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockClipboard.h>
#import <AquaSKKTesting/MockDynamicCompletor.h>
#import <AquaSKKTesting/MockMessenger.h>
#import <AquaSKKInput/AquaSKKInput-Preamble.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>
#import "TyperConfig.h"

TyperInputSessionParameter::TyperInputSessionParameter(id client, TyperConfig *config)
    : config_(new TyperConfig(*config)),
      frontend_(new SKKFrontEndAdapter([[MacFrontEndImpl alloc] initWithClient:client])),
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

void TyperInputSessionParameter::SetString(std::string pasteString) {
    MockClipboard *clipboard = dynamic_cast<MockClipboard *>(this->Clipboard());
    clipboard->SetString(pasteString);
}

std::vector<std::string> TyperInputSessionParameter::Candidates() {
    MockCandidateWindow *candidateWindow = dynamic_cast<MockCandidateWindow *>(this->CandidateWindow());

    std::vector<std::string> result;

    auto container = candidateWindow->Container();
    std::for_each(container.begin(), container.end(), [&result](const SKKCandidate &candidate) {
        std::string variant = candidate.Variant();
        result.push_back(variant);
    });

    return result;
}

int TyperInputSessionParameter::GetCandidateCursor() {
    MockCandidateWindow *candidateWindow = dynamic_cast<MockCandidateWindow *>(this->CandidateWindow());
    return candidateWindow->GetCursor();
}
int TyperInputSessionParameter::GetCandidatePage() {
    MockCandidateWindow *candidateWindow = dynamic_cast<MockCandidateWindow *>(this->CandidateWindow());
    return candidateWindow->GetPagePos();
}

std::string TyperInputSessionParameter::GetCompletion() {
    MockDynamicCompletor *dynamicCompletor = dynamic_cast<MockDynamicCompletor *>(this->DynamicCompletor());
    return dynamicCompletor->GetCompletion();
}
int TyperInputSessionParameter::GetCommonPrefixSize() {
    MockDynamicCompletor *dynamicCompletor = dynamic_cast<MockDynamicCompletor *>(this->DynamicCompletor());
    return dynamicCompletor->GetCommonPrefixSize();
}
int TyperInputSessionParameter::GetCursorOffset() {
    MockDynamicCompletor *dynamicCompletor = dynamic_cast<MockDynamicCompletor *>(this->DynamicCompletor());
    return dynamicCompletor->GetCursorOffset();
}

bool TyperInputSessionParameter::IsCompletionVisible() {
    MockDynamicCompletor *dynamicCompletor = dynamic_cast<MockDynamicCompletor *>(this->DynamicCompletor());
    return dynamicCompletor->IsVisible();
}

SKKCandidate TyperInputSessionParameter::GetAnnotation() {
    MockAnnotator *annotator = dynamic_cast<MockAnnotator *>(this->Annotator());
    return annotator->GetCandidate();
}
int TyperInputSessionParameter::GetAnnotationCursor() {
    MockAnnotator *annotator = dynamic_cast<MockAnnotator *>(this->Annotator());
    return annotator->GetCursor();
}
bool TyperInputSessionParameter::IsAnnotationVisible() {
    MockAnnotator *annotator = dynamic_cast<MockAnnotator *>(this->Annotator());
    return annotator->IsVisible();
}

TyperInputSessionParameter *TyperInputSessionParameter::Create(id client, TyperConfig *config) {
    return new TyperInputSessionParameter(client, config);
}

SKKInputSessionParameter *TyperInputSessionParameter::Coerce(TyperInputSessionParameter *params) {
    return params;
}

void TISRetain(TyperInputSessionParameter *params) {
    params->retain();
}

void TISRelease(TyperInputSessionParameter *params) {
    params->release();
}
