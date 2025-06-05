/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2008 Tomotaka SUWA <t.suwa@mac.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/

#ifndef SKKInputEngine_h
#define SKKInputEngine_h

#include <vector>
#import <swift/bridging>
#import <AquaSKKBackend/SKKInputMode.h>
#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKCompleterBuddy.h>
#import <AquaSKKEngine/SKKInputEnvironment.h>
#import <AquaSKKEngine/SKKInputQueueObserver.h>
#import <AquaSKKEngine/SKKOkuriListener.h>
#import <AquaSKKEngine/SKKSelectorBuddy.h>

@class SKKInputEngineImpl;

class SKKInputEngine : public SKKInputQueueObserver,
                       public SKKCompleterBuddy,
                       public SKKSelectorBuddy,
                       public SKKOkuriListener,
                       public IntrusiveRefCounted<SKKInputEngine> {
    SKKInputEngineImpl *impl_;

    // ローマ字かな変換通知
    virtual void SKKInputQueueUpdate(const SKKInputQueueObserverState &state) override;

    // 見出し語の取得
    virtual const std::string SKKCompleterQueryString();

    // 現在の見出し語の通知
    virtual void SKKCompleterUpdate(const std::string &entry);

    // SKKSelector::Execute() 時に呼び出される
    virtual const SKKEntry SKKSelectorQueryEntry();

    // SKKSelector で現在選択中の候補が変更された場合に呼び出される
    virtual void SKKSelectorUpdate(const SKKCandidate &candidate);

    // 送り入力中に見出し語部分が増えた場合に呼び出される
    virtual void SKKOkuriListenerAppendEntry(const std::string &fixed);

public:
    SKKInputEngineImpl *getImpl() {
        return impl_;
    }
    SKKInputEngine(SKKInputEnvironment *env);

    // 入力モード
    void SelectInputMode(SKKInputMode mode);

    // 状態変更
    void SetStatePrimary();
    void SetStateComposing();
    void SetStateOkuri();
    void SetStateSelectCandidate();
    void SetStateEntryRemove();
    void SetStateRegistration();

    // 入力
    void HandleChar(char code, bool direct);
    void HandleBackSpace();
    void HandleDelete();
    void HandleCursorLeft();
    void HandleCursorRight();
    void HandleCursorUp();
    void HandleCursorDown();
    void HandlePaste();
    void HandlePing();
    void HandleEnter();
    void HandleCancel();

    // 確定
    void Commit();

    // リセット
    void Reset();

    // トグル変換
    void ToggleKana();
    void ToggleJisx0201Kana();

    // 同期
    void UpdateInputContext();

    // ローマ字かな変換が発生するか？
    bool CanConvert(char code) const;

    // 送りが完成したか？
    bool IsOkuriComplete() const;

    virtual id<SKKCompleterBuddyProtcol> getCompleterBuddyProtocol() override;
    virtual id<SKKSelectorBuddyProtocol> getSelectorBuddyProtocol() override;

    virtual id<SKKOkuriListenerProtocol> getOkuriListenerProtocol() override;
    virtual id<SKKInputQueueObserverProtocol> getInputQueueObserverProtocol() override;
} SWIFT_SHARED_REFERENCE(retainSKKInputEngine, releaseSKKInputEngine);

void retainSKKInputEngine(SKKInputEngine *obj);
void releaseSKKInputEngine(SKKInputEngine *obj);

#endif
