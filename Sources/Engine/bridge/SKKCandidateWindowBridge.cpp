//
//  SKKCandidateWindowBridge.m
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#import "SKKCandidateWindowBridge.h"

SKKCandidateWindowBridge::SKKCandidateWindowBridge(SKKCandidateWindow *impl)
    : impl_(impl) {}

SKKCandidateWindowBridge::~SKKCandidateWindowBridge() {}

void SKKCandidateWindowBridge::Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages) {
    impl_->Setup(begin, end, pages);
}

std::vector<int> SKKCandidateWindowBridge::Setup(SKKCandidateContainer container) {
    std::vector<int> pages;
    Setup(container.begin(), container.end(), pages);
    return pages;
}

void SKKCandidateWindowBridge::Update(
    SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max) {
    impl_->Update(begin, end, cursor, page_pos, page_max);
}

void SKKCandidateWindowBridge::Update(SKKCandidateContainer container, int cursor, int page_pos, int page_max) {
    Update(container.begin(), container.end(), cursor, page_pos, page_max);
}

int SKKCandidateWindowBridge::LabelIndex(char label) {
    return impl_->LabelIndex(label);
}

void SKKCandidateWindowBridge::Show() {
    impl_->Show();
}

void SKKCandidateWindowBridge::Hide() {
    impl_->Hide();
}

void retainSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj) {
    obj->retain();
}

void releaseSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj) {
    obj->release();
}
