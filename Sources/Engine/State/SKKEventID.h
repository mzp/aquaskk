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

#endif /* SKKEventID_h */
