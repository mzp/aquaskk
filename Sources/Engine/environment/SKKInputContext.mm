//
//  SKKInputContext.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/04.
//

#include "SKKInputContext.h"
#import <AquaSKKBackend/AquaSKKBackend.h>

void retainSKKInputContext(SKKInputContext *obj) {
    obj->retain();
}

void releaseSKKInputContext(SKKInputContext *obj) {
    obj->release();
}

SKKCandidateBridge *SKKInputContext::getCandidateBridge() const {
    return [SKKCandidateBridge candidateFromCpp:&this->candidate];
}
