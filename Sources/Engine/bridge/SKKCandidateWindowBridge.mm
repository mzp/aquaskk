//
//  SKKCandidateWindowBridge.m
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#import "SKKCandidateWindowBridge.h"

void retainSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj) {
    obj->retain();
}

void releaseSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj) {
    obj->release();
}
