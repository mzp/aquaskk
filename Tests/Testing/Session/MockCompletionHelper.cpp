//
//  MockCompletionHelper.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockCompletionHelper.h"

void MockCompletionHelper::Initialize(const std::string &entry) {
    entry_ = entry;
    result_.clear();
}

std::vector<std::string> MockCompletionHelper::Result() {
    return result_;
}

const std::string &MockCompletionHelper::Entry() const {
    return entry_;
}

void MockCompletionHelper::Add(const std::string &completion) {
    result_.push_back(completion);
}

bool MockCompletionHelper::CanContinue() const {
    return true;
}

void SKKRetain(MockCompletionHelper *_Nonnull param) {
    param->retain();
}

void SKKRelease(MockCompletionHelper *_Nonnull param) {
    param->release();
}
