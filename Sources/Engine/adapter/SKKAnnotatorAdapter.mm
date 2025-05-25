//
//  SKKAnnotatorAdapter.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

#include "SKKAnnotatorAdapter.h"
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKAnnotatorAdapter::SKKAnnotatorAdapter(id<SKKAnnotatorProtocol> impl) {
    impl_ = impl;
}

SKKAnnotatorAdapter::~SKKAnnotatorAdapter() {}

void SKKAnnotatorAdapter::Update(const SKKCandidate &candidate, int cursorOffset) {
    SKKCandidateBridge *bridge = [SKKCandidateBridge candidateFromCpp:&candidate];
    [impl_ update:bridge cursorOffset:cursorOffset];
}

void SKKAnnotatorAdapter::SKKWidgetShow() {
    [impl_ skkWidgetShow];
}

void SKKAnnotatorAdapter::SKKWidgetHide() {
    [impl_ skkWidgetHide];
}
