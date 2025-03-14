//
//  SKKEventID.h
//  AquaSKK
//
//  Created by mzp on 2025/03/14.
//

#ifndef SKKEventID_h
#define SKKEventID_h

namespace statemachinecxx_sourceforge_jp {
    // ======================================================================
    // event types
    // ======================================================================
    enum EventTypes { EXIT_EVENT = -3, INIT_EVENT = -2, ENTRY_EVENT = -1, PROBE = 0, USER_EVENT = 1 };
}; // namespace statemachinecxx_sourceforge_jp

// キー入力イベント
enum {
    SKK_NULL = statemachinecxx_sourceforge_jp::USER_EVENT, // 無効なイベント
    SKK_JMODE,                                             // Ctrl-J
    SKK_ENTER,                                             // Ctrl-M
    SKK_CANCEL,                                            // Ctrl-G
    SKK_BACKSPACE,                                         // Ctrl-H
    SKK_DELETE,                                            // Ctrl-D
    SKK_TAB,                                               // Ctrl-I
    SKK_PASTE,                                             // Ctrl-Y
    SKK_LEFT,                                              // ←
    SKK_RIGHT,                                             // →
    SKK_UP,                                                // ↑
    SKK_DOWN,                                              // ↓
    SKK_CHAR,                                              // その他全てのキー入力
    SKK_PING,                                              // CTRL-L(内部状態問い合わせ)
    SKK_UNDO,                                              // CTRL-/
    SKK_ASCII_MODE,                                        // ASCII モード
    SKK_HIRAKANA_MODE,                                     // ひらかなモード
    SKK_KATAKANA_MODE,                                     // カタカナモード
    SKK_JISX0201KANA_MODE,                                 // 半角カナモード
    SKK_JISX0208LATIN_MODE,                                // 全角英数モード
    SKK_YES,                                               // 仮想イベント
    SKK_NO,                                                // 仮想イベント
    SKK_ON,                                                // 仮想イベント
    SKK_OFF                                                // 仮想イベント
};

// キー入力イベント
enum class SKKEventID {
    exitEvent = statemachinecxx_sourceforge_jp::EXIT_EVENT,
    initEvent = statemachinecxx_sourceforge_jp::INIT_EVENT,
    entryEvent = statemachinecxx_sourceforge_jp::ENTRY_EVENT,
    probeEvent = statemachinecxx_sourceforge_jp::PROBE,
    null = statemachinecxx_sourceforge_jp::USER_EVENT, // 無効なイベント
    jmode = SKK_JMODE,
    enter = SKK_ENTER,
    cancel = SKK_CANCEL,
    backspace = SKK_BACKSPACE,
    delete_ = SKK_DELETE,
    tab = SKK_TAB,
    paste = SKK_PASTE,
    left = SKK_LEFT,
    right = SKK_RIGHT,
    up = SKK_UP,
    down = SKK_DOWN,
    charInput = SKK_CHAR,
    ping = SKK_PING,
    undo = SKK_UNDO,
    asciiMode = SKK_ASCII_MODE,
    hirakanaMode = SKK_HIRAKANA_MODE,
    katakanaMode = SKK_KATAKANA_MODE,
    jisx0201KanaMode = SKK_JISX0201KANA_MODE,
    jisx0208LatinMode = SKK_JISX0208LATIN_MODE,
    yes = SKK_YES,
    no = SKK_NO,
    on = SKK_ON,
    off = SKK_OFF
};

#endif /* SKKEventID_h */
