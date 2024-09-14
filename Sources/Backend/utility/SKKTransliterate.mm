//
//  SKKTransliterate.c
//  AquaSKKBackend
//
//  Created by mzp on 8/31/24.
//

#include "SKKTransliterate.h"
#import <Foundation/Foundation.h>

namespace SKKTransliterate {
    void hirakana_to_katakana(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformHiraganaToKatakana
                       reverse:NO
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }

    void hirakana_to_jisx0201_kana(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformHiraganaToKatakana
                       reverse:NO
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:NO
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void hirakana_to_roman(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformLatinToHiragana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void katakana_to_hirakana(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformHiraganaToKatakana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void katakana_to_jisx0201_kana(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:NO
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void katakana_to_roman(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformHiraganaToKatakana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        [string applyTransform:NSStringTransformLatinToHiragana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void jisx0201_kana_to_hirakana(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        [string applyTransform:NSStringTransformHiraganaToKatakana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void jisx0201_kana_to_katakana(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void jisx0201_kana_to_roman(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        [string applyTransform:NSStringTransformHiraganaToKatakana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        [string applyTransform:NSStringTransformLatinToHiragana
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void ascii_to_jisx0208_latin(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:YES
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
    void jisx0208_latin_to_ascii(const std::string &from, std::string &to) {
        NSMutableString *string = [NSMutableString stringWithUTF8String:from.c_str()];
        [string applyTransform:NSStringTransformFullwidthToHalfwidth
                       reverse:NO
                         range:NSMakeRange(0, string.length)
                  updatedRange:nil];
        to = std::string([string UTF8String]);
    }
} // namespace SKKTransliterate
