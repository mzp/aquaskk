//
//  SKKCompleterBuddy.h
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

#ifndef SKKCompleterBuddy_h
#define SKKCompleterBuddy_h

#include <string>
#include <swift/bridging>
#import <AquaSKKEngine/IntrusiveRefCounted.h>

@protocol SKKCompleterBuddyProtcol;

// 補完サポートクラス
struct SKKCompleterBuddy : public IntrusiveRefCounted<SKKCompleterBuddy> {
    virtual ~SKKCompleterBuddy() {}
    virtual id<SKKCompleterBuddyProtcol> getProtocol() = 0;
} SWIFT_SHARED_REFERENCE(retainSKKCompleterBuddy, releaseSKKCompleterBuddy);

void retainSKKCompleterBuddy(SKKCompleterBuddy *obj);
void releaseSKKCompleterBuddy(SKKCompleterBuddy *obj);

#endif /* SKKCompleterBuddy_h */
