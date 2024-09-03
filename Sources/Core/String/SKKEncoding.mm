//
//  SKKStringFunctions.c
//  AquaSKKCore
//
//  Created by mzp on 8/31/24.
//

#import "SKKEncoding.h"
#import <Foundation/Foundation.h>

namespace SKKEncoding {
    void convert_utf8_to_eucj(const std::string &from, std::string &to) {
        to = eucj_from_utf8(from);
    }
    void convert_eucj_to_utf8(const std::string &from, std::string &to) {
        to = utf8_from_eucj(from);
    }

    std::string utf8_from_eucj(const std::string &eucj) {
        NSString *string = [NSString stringWithCString:eucj.c_str() encoding:NSJapaneseEUCStringEncoding];
        const char *utf8 = [string UTF8String];
        return std::string(utf8);
    }
    std::string eucj_from_utf8(const std::string &utf8) {
        NSString *string = [NSString stringWithUTF8String:utf8.c_str()];
        NSData *data = [string dataUsingEncoding:NSJapaneseEUCStringEncoding];
        return std::string((const char *)data.bytes);
    }
} // namespace SKKEncoding
