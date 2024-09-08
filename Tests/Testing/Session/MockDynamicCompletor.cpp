//
//  MockDynamicCompletor.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockDynamicCompletor.h"

void MockDynamicCompletor::SKKWidgetShow() {
    visible_ = true;
}
void MockDynamicCompletor::SKKWidgetHide() {
    visible_ = false;
}
bool MockDynamicCompletor::IsVisible() {
    return visible_;
}
void MockDynamicCompletor::Update(const std::string &completion, int commonPrefixSize, int cursorOffset) {
    completion_ = completion;
    commonPrefixSize_ = commonPrefixSize;
    cursorOffset_ = cursorOffset;
}

std::string MockDynamicCompletor::GetCompletion() {
    return completion_;
}
int MockDynamicCompletor::GetCommonPrefixSize() {
    return commonPrefixSize_;
}
int MockDynamicCompletor::GetCursorOffset() {
    return cursorOffset_;
}
