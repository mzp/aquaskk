//
//  SKKCandidateSuite.cpp
//  AquaSKKBackend
//
//  Created by mzp on 2025/05/14.
//

#include "SKKCandidateSuite.h"
#import <AquaSKKBackend/AquaSKKBackend-Preamble.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

void SKKCandidateSuite::Parse(const std::string str) {
    auto parser = AquaSKKBackend::SKKCandidateParser::init();
    parser.parse(str);

    candidates_.clear();
    for(auto candidate : parser.getCandidates()) {
        candidates_.push_back(candidate);
    }

    hints_.clear();
    for(auto hint : parser.getHints()) {
        hints_.push_back(hint);
    }
}
