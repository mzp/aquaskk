//
//  SKKInputQueueObserver.h
//  AquaSKK
//
//  Created by mzp on 2025/03/03.
//

#ifndef SKKInputQueueObserver_h
#define SKKInputQueueObserver_h

#include <string>

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

#endif /* SKKInputQueueObserver_h */
