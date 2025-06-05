//
//  SKKCandidateWindowAdapter.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

#include "SKKCandidateWindowAdapter.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKCandidateWindowAdapter::SKKCandidateWindowAdapter(id<SKKCandidateWindowProtocol> impl) {
    impl_ = impl;
}

SKKCandidateWindowAdapter::~SKKCandidateWindowAdapter() {}

void SKKCandidateWindowAdapter::Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages) {
    NSMutableArray<NSString *> *candidadets = [NSMutableArray array];

    while(begin != end) {
        std::string candidate(begin->Variant());
        [candidadets addObject:[NSString stringWithUTF8String:candidate.c_str()]];
        ++begin;
    }
    pages.clear();
    NSArray<NSNumber *> *ret = [(id<SKKCandidateWindowProtocol>)impl_ setupWithCandidates:candidadets];
    for(NSNumber *n in ret) {
        pages.push_back(static_cast<int>(n.integerValue));
    }
}

void SKKCandidateWindowAdapter::Update(
    SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max) {

    NSMutableArray<NSString *> *candidadets = [NSMutableArray array];

    while(begin != end) {
        std::string candidate(begin->Variant());
        [candidadets addObject:[NSString stringWithUTF8String:candidate.c_str()]];
        ++begin;
    }
    [impl_ updateWithCandidates:candidadets cursor:cursor position:page_pos max:page_max];
}

int SKKCandidateWindowAdapter::LabelIndex(char label) {
    return static_cast<int>([impl_ labelIndexOf:label]);
}

void SKKCandidateWindowAdapter::SKKWidgetShow() {
    [impl_ skkWidgetShow];
}

void SKKCandidateWindowAdapter::SKKWidgetHide() {
    [impl_ skkWidgetHide];
}
