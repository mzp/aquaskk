//
//  SKKStringFunctions.h
//  AquaSKKBackend
//
//  Created by mzp on 8/31/24.
//

#ifndef SKKStringFunctions_h
#define SKKStringFunctions_h

#include <string>

namespace SKKEncoding {
    void convert_utf8_to_eucj(const std::string &from, std::string &to);
    void convert_eucj_to_utf8(const std::string &from, std::string &to);

    std::string utf8_from_eucj(const std::string &eucj);
    std::string eucj_from_utf8(const std::string &utf8);
} // namespace SKKEncoding

#endif /* SKKStringFunctions_h */
