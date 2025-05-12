//
//  SKKKeyModifier.h
//  AquaSKK
//
//  Created by mzp on 2/9/25.
//

#ifndef SKKKeyModifier_h
#define SKKKeyModifier_h

enum class SKKKeyModifier {
    shift = 1 << 1,
    control = 1 << 2,
    option = 1 << 3,
    command = 1 << 4
};

#endif /* SKKKeyModifier_h */
