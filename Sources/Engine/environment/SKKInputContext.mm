//
//  SKKInputContext.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/04.
//

#include "SKKInputContext.h"
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKInputContext::SKKInputContext(id<SKKFrontEndProtocol> frontend)
    : output([[SKKOutputBufferImpl alloc] initWithFrontend:frontend]),
      undo([[SKKUndoContextImpl alloc] initWithFrontend:frontend]),
      dynamic_completion(false) {}

void retainSKKInputContext(SKKInputContext *obj) {
    obj->retain();
}

void releaseSKKInputContext(SKKInputContext *obj) {
    obj->release();
}

SKKCandidateBridge *SKKInputContext::getCandidateBridge() const {
    return [SKKCandidateBridge candidateFromCpp:&this->candidate];
}
