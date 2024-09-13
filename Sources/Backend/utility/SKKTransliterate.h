//
//  SKKTransliterate.h
//  AquaSKKBackend
//
//  Created by mzp on 8/31/24.
//

#ifndef SKKTransliterate_h
#define SKKTransliterate_h

#include <string>

namespace SKKTransliterate {
    void hirakana_to_katakana(const std::string &from, std::string &to);
    void hirakana_to_jisx0201_kana(const std::string &from, std::string &to);
    void hirakana_to_roman(const std::string &from, std::string &to);
    void katakana_to_hirakana(const std::string &from, std::string &to);
    void katakana_to_jisx0201_kana(const std::string &from, std::string &to);
    void katakana_to_roman(const std::string &from, std::string &to);
    void jisx0201_kana_to_hirakana(const std::string &from, std::string &to);
    void jisx0201_kana_to_katakana(const std::string &from, std::string &to);
    void jisx0201_kana_to_roman(const std::string &from, std::string &to);
    void ascii_to_jisx0208_latin(const std::string &from, std::string &to);
    void jisx0208_latin_to_ascii(const std::string &from, std::string &to);
} // namespace SKKTransliterate

#endif /* SKKTransliterate_h */
