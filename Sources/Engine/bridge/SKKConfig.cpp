//
//  SKKConfig.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

#import <AquaSKKEngine/SKKConfig.h>

void retainSKKConfig(SKKConfig *obj) {
    obj->retain();
}
void releaseSKKConfig(SKKConfig *obj) {
    obj->release();
}
