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

/// 入力状態
struct SKKInputQueueObserverState {
    /// 確定した文字
    std::string fixed;
    /// 最小マッチした文字
    std::string intermediate;
    /// 入力バッファ
    std::string queue;
    /// 入力文字
    char code;
};

class SKKInputQueueObserver : public IntrusiveRefCounted<SKKInputQueueObserver> {
public:
    virtual ~SKKInputQueueObserver() {}

    virtual void SKKInputQueueUpdate(const SKKInputQueueObserverState &state) {}
} SWIFT_SHARED_REFERENCE(retainSKKInputQueueObserver, releaseSKKInputQueueObserver);

void retainSKKInputQueueObserver(SKKInputQueueObserver *obj);
void releaseSKKInputQueueObserver(SKKInputQueueObserver *obj);

#endif /* SKKInputQueueObserver_h */
