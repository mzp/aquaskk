//
//  SKKStringFunctions.c
//  AquaSKKCore
//
//  Created by mzp on 8/31/24.
//

#include "SKKEncoding.h"

#include "jconv.h"

namespace SKKEncoding {
    void convert_utf8_to_eucj(const std::string &from, std::string &to) {
        jconv::convert_utf8_to_eucj(from, to);
    }
    void convert_eucj_to_utf8(const std::string &from, std::string &to) {
        jconv::convert_eucj_to_utf8(from, to);
    }

    std::string utf8_from_eucj(const std::string &eucj) {
        return jconv::utf8_from_eucj(eucj);
    }
    std::string eucj_from_utf8(const std::string &utf8) {
        return jconv::eucj_from_utf8(utf8);
    }
} // namespace SKKEncoding
