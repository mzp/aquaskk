//
//  MockAnnotator.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockAnnotator.h"

void MockAnnotator::SKKWidgetShow() {
    visible_ = true;
}

void MockAnnotator::SKKWidgetHide() {
    visible_ = false;
}

void MockAnnotator::Update(const SKKCandidate &candidate, int cursor) {
    candidate_ = candidate;
    cursor_ = cursor;
}

bool MockAnnotator::IsVisible() {
    return visible_;
}

SKKCandidate &MockAnnotator::GetCandidate() {
    return candidate_;
}

int MockAnnotator::GetCursor() {
    return cursor_;
}
