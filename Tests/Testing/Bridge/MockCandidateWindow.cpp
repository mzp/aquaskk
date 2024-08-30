//
//  MockCandidateWindow.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockCandidateWindow.h"

void MockCandidateWindow::SKKWidgetShow() {}
void MockCandidateWindow::SKKWidgetHide() {}

void MockCandidateWindow::Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    pages.push_back(end - begin);
#pragma clang diagnostic pop
}

void MockCandidateWindow::Update(
    SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max) {}

int MockCandidateWindow::LabelIndex(char label) {
    return 0;
}
