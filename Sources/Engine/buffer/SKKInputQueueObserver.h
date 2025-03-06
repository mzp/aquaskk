//
//  SKKInputQueueObserver.h
//  AquaSKK
//
//  Created by mzp on 2025/03/03.
//

#ifndef SKKInputQueueObserver_h
#define SKKInputQueueObserver_h

#include <string>
#include <swift/bridging>
#import <AquaSKKEngine/IntrusiveRefCounted.h>

class SKKInputQueueObserver : public IntrusiveRefCounted<SKKInputQueueObserver> {
public:
    // 入力状態
    struct State {
        std::string fixed;        // 確定した文字
        std::string intermediate; // 最小マッチした文字
        std::string queue;        // 入力バッファ
        char code;                // 入力文字
    };

    virtual ~SKKInputQueueObserver() {}

    virtual void SKKInputQueueUpdate(const State &state) {}
} SWIFT_SHARED_REFERENCE(retainSKKInputQueueObserver, releaseSKKInputQueueObserver);

void retainSKKInputQueueObserver(SKKInputQueueObserver *obj);
void releaseSKKInputQueueObserver(SKKInputQueueObserver *obj);

#endif /* SKKInputQueueObserver_h */
