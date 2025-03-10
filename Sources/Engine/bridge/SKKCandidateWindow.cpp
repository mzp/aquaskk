//
//  SKKCandidateWindow.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/10.
//

#include <AquaSKKEngine/SKKCandidateWindow.h>

void retainSKKCandidateWindow(SKKCandidateWindow *obj) {
    obj->retain();
}
void releaseSKKCandidateWindow(SKKCandidateWindow *obj) {
    obj->release();
}
