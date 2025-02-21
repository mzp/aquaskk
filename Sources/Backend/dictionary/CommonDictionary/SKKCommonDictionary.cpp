//
//  SKKCommonDictionary.cpp
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

#include "SKKCommonDictionary.h"
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

SKKCommonDictionary::SKKCommonDictionary()
: impl_(new SwiftObject<AquaSKKBackend::SKKCommonDictionaryEUCJP>()) {}

SKKCommonDictionary::~SKKCommonDictionary() {
    delete impl_;
}
void SKKCommonDictionary::Initialize(const std::string &path) {
    (*impl_)->initialize(path);
}
void SKKCommonDictionary::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    (*impl_)->find(entry, result);
}
std::string SKKCommonDictionary::ReverseLookup(const std::string &candidate) {
    return (*impl_)->reverseLookup(candidate);
}

void SKKCommonDictionary::Complete(SKKCompletionHelper &helper) {
    auto bridge = SKKCompletionHelperBridge(&helper);
    (*impl_)->complete(bridge);
}


SKKCommonDictionaryUTF8::SKKCommonDictionaryUTF8()
: impl_(new SwiftObject<AquaSKKBackend::SKKCommonDictionaryUTF8>()) {}

SKKCommonDictionaryUTF8::~SKKCommonDictionaryUTF8() {
    delete impl_;
}
void SKKCommonDictionaryUTF8::Initialize(const std::string &path) {
    (*impl_)->initialize(path);
}
void SKKCommonDictionaryUTF8::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    (*impl_)->find(entry, result);
}
std::string SKKCommonDictionaryUTF8::ReverseLookup(const std::string &candidate) {
    return (*impl_)->reverseLookup(candidate);
}

void SKKCommonDictionaryUTF8::Complete(SKKCompletionHelper &helper) {
    auto bridge = SKKCompletionHelperBridge(&helper);
    (*impl_)->complete(bridge);
}
