//
//  MockConfig.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TyperConfig.h"

TyperConfig::TyperConfig()
    : intermediateConversion_(true),
      enableDynamicCompletion_(true),
      dynamicCompletionRange_(1),
      enableAnnotation_(true),
      suppressNewlineOnCommit_(true),
      maxCountOfInlineCandidates_(5),
      deleteOkuriWhenQuit_(true) {}

TyperConfig::TyperConfig(const TyperConfig &other)
    : intermediateConversion_(other.intermediateConversion_),
      enableDynamicCompletion_(other.enableDynamicCompletion_),
      dynamicCompletionRange_(other.dynamicCompletionRange_),
      enableAnnotation_(other.enableAnnotation_),
      suppressNewlineOnCommit_(other.suppressNewlineOnCommit_),
      maxCountOfInlineCandidates_(other.maxCountOfInlineCandidates_),
      deleteOkuriWhenQuit_(other.deleteOkuriWhenQuit_),
      inlineBackSpaceImpliesCommit_(other.inlineBackSpaceImpliesCommit_),
      handleRecursiveEntryAsOkuri_(other.handleRecursiveEntryAsOkuri_) {}

TyperConfig::~TyperConfig() {}

bool TyperConfig::FixIntermediateConversion() {
    return intermediateConversion_;
}

void TyperConfig::SetFixIntermediateConversion(bool value) {
    this->intermediateConversion_ = value;
}

bool TyperConfig::EnableDynamicCompletion() {
    return enableDynamicCompletion_;
}

void TyperConfig::SetEnableDynamicCompletion(bool value) {
    this->enableDynamicCompletion_ = value;
}

int TyperConfig::DynamicCompletionRange() {
    return dynamicCompletionRange_;
}

void TyperConfig::SetDynamicCompletionRange(int value) {
    this->dynamicCompletionRange_ = value;
}

bool TyperConfig::EnableAnnotation() {
    return enableAnnotation_;
}

void TyperConfig::SetEnableAnnotation(bool value) {
    this->enableAnnotation_ = value;
}

bool TyperConfig::DisplayShortestMatchOfKanaConversions() {
    return displayShortestMatchOfKanaConversions_;
}
void TyperConfig::SetDisplayShortestMatchOfKanaConversions(bool value) {
    this->displayShortestMatchOfKanaConversions_ = value;
}

bool TyperConfig::SuppressNewlineOnCommit() {
    return suppressNewlineOnCommit_;
}

void TyperConfig::SetSuppressNewlineOnCommit(bool value) {
    this->suppressNewlineOnCommit_ = value;
}

int TyperConfig::MaxCountOfInlineCandidates() {
    return maxCountOfInlineCandidates_;
}

void TyperConfig::SetMaxCountOfInlineCandidates(int value) {
    this->maxCountOfInlineCandidates_ = value;
}

bool TyperConfig::HandleRecursiveEntryAsOkuri() {
    return handleRecursiveEntryAsOkuri_;
}

void TyperConfig::SetHandleRecursiveEntryAsOkuri(bool value) {
    this->handleRecursiveEntryAsOkuri_ = value;
}

bool TyperConfig::InlineBackSpaceImpliesCommit() {
    return inlineBackSpaceImpliesCommit_;
}

void TyperConfig::SetInlineBackSpaceImpliesCommit(bool value) {
    this->inlineBackSpaceImpliesCommit_ = value;
}

bool TyperConfig::DeleteOkuriWhenQuit() {
    return deleteOkuriWhenQuit_;
}

void TyperConfig::SetDeleteOkuriWhenQuit(bool value) {
    this->deleteOkuriWhenQuit_ = value;
}

TyperConfig *TyperConfig::newInstannce() {
    return new TyperConfig();
}

void retainTyperConfig(TyperConfig *params) {
    params->retain();
}

void releaseTyperConfig(TyperConfig *params) {
    params->release();
}
