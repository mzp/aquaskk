//
//  SKKTransliterate.c
//  AquaSKKCore
//
//  Created by mzp on 8/31/24.
//

#include "SKKTransliterate.h"

#include "jconv.h"

namespace SKKTransliterate {
    void hirakana_to_katakana(const std::string &from, std::string &to) {
        jconv::hirakana_to_katakana(from, to);
    }
    void hirakana_to_jisx0201_kana(const std::string &from, std::string &to) {
        jconv::hirakana_to_jisx0201_kana(from, to);
    }
    void hirakana_to_roman(const std::string &from, std::string &to) {
        jconv::hirakana_to_roman(from, to);
    }
    void katakana_to_hirakana(const std::string &from, std::string &to) {
        jconv::katakana_to_hirakana(from, to);
    }
    void katakana_to_jisx0201_kana(const std::string &from, std::string &to) {
        jconv::katakana_to_jisx0201_kana(from, to);
    }
    void katakana_to_roman(const std::string &from, std::string &to) {
        jconv::katakana_to_roman(from, to);
    }
    void jisx0201_kana_to_hirakana(const std::string &from, std::string &to) {
        jconv::jisx0201_kana_to_hirakana(from, to);
    }
    void jisx0201_kana_to_katakana(const std::string &from, std::string &to) {
        jconv::jisx0201_kana_to_katakana(from, to);
    }
    void jisx0201_kana_to_roman(const std::string &from, std::string &to) {
        jconv::jisx0201_kana_to_roman(from, to);
    }
    void ascii_to_jisx0208_latin(const std::string &from, std::string &to) {
        jconv::ascii_to_jisx0208_latin(from, to);
    }
    void jisx0208_latin_to_ascii(const std::string &from, std::string &to) {
        jconv::jisx0208_latin_to_ascii(from, to);
    }
} // namespace SKKTransliterate
