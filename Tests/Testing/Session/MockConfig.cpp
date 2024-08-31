//
//  MockConfig.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockConfig.h"

bool MockConfig::FixIntermediateConversion() {
    return true;
}
bool MockConfig::EnableDynamicCompletion() {
    return false;
}
int MockConfig::DynamicCompletionRange() {
    return 0;
}
bool MockConfig::EnableAnnotation() {
    return false;
}
bool MockConfig::DisplayShortestMatchOfKanaConversions() {
    return false;
}
bool MockConfig::SuppressNewlineOnCommit() {
    return true;
}
int MockConfig::MaxCountOfInlineCandidates() {
    return 5;
}
bool MockConfig::HandleRecursiveEntryAsOkuri() {
    return false;
}
bool MockConfig::InlineBackSpaceImpliesCommit() {
    return false;
}
bool MockConfig::DeleteOkuriWhenQuit() {
    return true;
}
