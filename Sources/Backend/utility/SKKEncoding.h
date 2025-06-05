//
//  SKKStringFunctions.h
//  AquaSKKBackend
//
//  Created by mzp on 8/31/24.
//

#ifndef SKKStringFunctions_h
#define SKKStringFunctions_h

#include <string>
#include <vector>
#import <Foundation/Foundation.h>

namespace SKKEncoding {
    void convert_utf8_to_eucj(const std::string &from, std::string &to);
    void convert_eucj_to_utf8(const std::string &from, std::string &to);

    std::string utf8_from_eucj(const std::string &eucj);
    std::string eucj_from_utf8(const std::string &utf8);
} // namespace SKKEncoding

// std::stringはcharからしか作れないはずだが、unsigned charが格納されることを前提としたコードになっている。
// Swiftではうまく作れなかったので、C側で無理やり作る。
std::string SKKRawString(const uint8_t array[]);
std::vector<uint8_t> SKKRawArray(const std::string string);

NS_ASSUME_NONNULL_BEGIN
NSString *SKKUTF8String(std::string utf8);
NS_ASSUME_NONNULL_END

#endif /* SKKStringFunctions_h */
