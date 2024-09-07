//
//  MockConfig.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TyperConfig.h"

bool TyperConfig::FixIntermediateConversion() {
    return true;
}
bool TyperConfig::EnableDynamicCompletion() {
    return true;
}
void TyperConfig::SetEnableDynamicCompletion(bool value) {
    this->dynamicCompletion_ = value;
}

int TyperConfig::DynamicCompletionRange() {
    return 1;
}
bool TyperConfig::EnableAnnotation() {
    return false;
}
bool TyperConfig::DisplayShortestMatchOfKanaConversions() {
    return false;
}
bool TyperConfig::SuppressNewlineOnCommit() {
    return true;
}
int TyperConfig::MaxCountOfInlineCandidates() {
    return 5;
}
bool TyperConfig::HandleRecursiveEntryAsOkuri() {
    return false;
}
bool TyperConfig::InlineBackSpaceImpliesCommit() {
    return false;
}
bool TyperConfig::DeleteOkuriWhenQuit() {
    return true;
}
