//
//  SKKRegistration.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

#include "SKKRegistration.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKRegistration::SKKRegistration()
:impl_(new SwiftObject(AquaSKKEngine::SKKRegistrationImpl::init())){

}
//    : state_(SKKRegistrationState::None) {}

void SKKRegistration::Start() {
//    state_ = SKKRegistrationState::Started;
    (*impl_)->start();
}

void SKKRegistration::Finish(const std::string &str) {
//    state_ = SKKRegistrationState::Finished;
//    word_ = str;
    (*impl_)->finish(str);
}

void SKKRegistration::Abort() {
//    state_ = SKKRegistrationState::Aborted;
//    word_.clear();
    (*impl_)->abort();
}

void SKKRegistration::Clear() {
//    state_ = SKKRegistrationState::None;
//    word_.clear();
    (*impl_)->clear();
}

const SKKRegistrationState SKKRegistration::getState() const {
//    return state_;
    (*impl_)->getState();
}
const std::string SKKRegistration::getWord() const SWIFT_COMPUTED_PROPERTY {
//    return word_;
    (*impl_)->getWord();
}

const std::string &SKKRegistration::Word() const {
//    return word_;
    (*impl_)->getWord();
}
