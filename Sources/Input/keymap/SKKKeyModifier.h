//
//  SKKKeyModifier.h
//  AquaSKK
//
//  Created by mzp on 2/9/25.
//

#ifndef SKKKeyModifier_h
#define SKKKeyModifier_h

#include <AquaSKKInput/SKKKeyState.h>

enum class SKKKeyModifier {
    shift = SKKKeyState::SHIFT,
    control = SKKKeyState::CTRL,
    option = SKKKeyState::ALT,
    command = SKKKeyState::META
};

#endif /* SKKKeyModifier_h */
