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
// 補完サポートクラス
struct SKKCompleterBuddy: public IntrusiveRefCounted<SKKCompleterBuddy> {
    virtual ~SKKCompleterBuddy() {}

    // 見出し語の取得
    virtual const std::string SKKCompleterQueryString() = 0;

    // 現在の見出し語の通知
    virtual void SKKCompleterUpdate(const std::string &entry) = 0;

    static std::string InvokeSKKCompleterQueryString(SKKCompleterBuddy *obj);
    static void InvokeSKKCompleterUpdate(SKKCompleterBuddy *obj, std::string entry);
} SWIFT_SHARED_REFERENCE(retainSKKCompleterBuddy, releaseSKKCompleterBuddy);

void retainSKKCompleterBuddy(SKKCompleterBuddy *obj);
void releaseSKKCompleterBuddy(SKKCompleterBuddy *obj);


#endif /* SKKCompleterBuddy_h */
