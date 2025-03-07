//
//  SKKRegistration.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

#include "SKKRegistration.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#import <AquaSKKBackend/SwiftObject.h>

class SKKRegistrationContainer {
public:
    SwiftObject<AquaSKKEngine::SKKRegistrationImpl> *impl_;

    SKKRegistrationContainer()
    :impl_(new SwiftObject(AquaSKKEngine::SKKRegistrationImpl::init())){
        {

        }
    }
};

SKKRegistration::SKKRegistration()
    :container_(new SKKRegistrationContainer())
    {}

void SKKRegistration::Start() {
    (*(container_->impl_))->start();
}

void SKKRegistration::Finish(const std::string &str) {
    (*(container_->impl_))->finish(str);
}

void SKKRegistration::Abort() {
    (*(container_->impl_))->abort();
}

void SKKRegistration::Clear() {
    (*(container_->impl_))->clear();
}

const SKKRegistrationState SKKRegistration::getState() const {
    return (*(container_->impl_))->bridgedState();
}
const std::string SKKRegistration::getWord() const SWIFT_COMPUTED_PROPERTY {
    return (*(container_->impl_))->bridgedWord();
}

const std::string SKKRegistration::Word() const {
    return (*(container_->impl_))->bridgedWord();
}
