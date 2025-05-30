//
//  SKKOkuriListener.h
//  AquaSKK
//
//  Created by mzp on 2025/03/05.
//

#ifndef SKKOkuriListener_h
#define SKKOkuriListener_h

#include <string>
#include <swift/bridging>
#include <AquaSKKEngine/IntrusiveRefCounted.h>

@protocol SKKOkuriListenerProtocol;

class SKKOkuriListener : public IntrusiveRefCounted<SKKOkuriListener> {
public:
    virtual ~SKKOkuriListener() {}

    virtual id<SKKOkuriListenerProtocol> getOkuriListenerProtocol() = 0;
} SWIFT_SHARED_REFERENCE(retainSKKOkuriListener, releaseSKKOkuriListener);

void retainSKKOkuriListener(SKKOkuriListener *obj);

void releaseSKKOkuriListener(SKKOkuriListener *obj);

#endif /* SKKOkuriListener_h */
