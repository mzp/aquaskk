//
//  SKKAutoUpdateDictionary.cpp
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

#include "SKKAutoUpdateDictionary.h"
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

SKKAutoUpdateDictionary::SKKAutoUpdateDictionary()
    : impl_(new SwiftObject<AquaSKKBackend::SKKAutoUpdateDictionary>()) {}

SKKAutoUpdateDictionary::~SKKAutoUpdateDictionary() {
    delete impl_;
}
void SKKAutoUpdateDictionary::Initialize(const std::string &path) {
    (*impl_)->initialize(path);
}
void SKKAutoUpdateDictionary::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    (*impl_)->find(entry, result);
}
std::string SKKAutoUpdateDictionary::ReverseLookup(const std::string &candidate) {
    return (*impl_)->reverseLookup(candidate);
}

void SKKAutoUpdateDictionary::Complete(SKKCompletionHelper &helper) {
    auto bridge = SKKCompletionHelperBridge(&helper);
    (*impl_)->complete(bridge);
}
