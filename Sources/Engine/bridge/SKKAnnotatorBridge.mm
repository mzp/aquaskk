//
//  SKKAnnotatorBridge.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

#include "SKKAnnotatorBridge.h"
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKAnnotatorBridge::SKKAnnotatorBridge(id<SKKAnnotatorProtocol> impl) {
    impl_ = impl;
}

SKKAnnotatorBridge::~SKKAnnotatorBridge() {}

void SKKAnnotatorBridge::Update(const SKKCandidate &candidate, int cursorOffset) {
    SKKCandidateBridge *bridge = [SKKCandidateBridge candidateFromCpp:&candidate];
    [impl_ update:bridge cursorOffset:cursorOffset];
}

void SKKAnnotatorBridge::SKKWidgetShow() {
    [impl_ skkWidgetShow];
}

void SKKAnnotatorBridge::SKKWidgetHide() {
    [impl_ skkWidgetHide];
}
