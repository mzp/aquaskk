//
//  SKKOkuriListener.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

#include <AquaSKKEngine/SKKOkuriListener.h>

void retainSKKOkuriListener(SKKOkuriListener *obj) {
    obj->retain();
}

void releaseSKKOkuriListener(SKKOkuriListener *obj) {
    obj->release();
}
