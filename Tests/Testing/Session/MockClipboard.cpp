//
//  MockClipboard.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockClipboard.h"

const std::string MockClipboard::PasteString() {
    return str_;
}

void MockClipboard::SetString(const std::string &str) {
    str_ = str;
}
