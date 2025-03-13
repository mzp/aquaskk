//
//  SKKBridgedState.h
//  AquaSKK
//
//  Created by mzp on 2025/03/13.
//

#ifndef SKKBridgedState_h
#define SKKBridgedState_h
#import <AquaSKKEngine/SKKEvent.h>

// キー入力イベント
enum class SKKBridgedEventID {
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


enum class SKKStateMachineAction {
    handled,

    initializeKanaInput,

    transitionAsciiMode,
    transitionHirakanaMode,
    transitionKatakanaMode,
    transitionJisx0201KanaMode,
    transitionJisx0208LatinMode,
    transitionKanaEntry,
    transitionAsciiEntry,

    delegateTopState

};

#endif /* SKKBridgedState_h */
