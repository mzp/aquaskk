//
//  TyperInputSessionParameter.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TyperInputSessionParameter.h"
#import <AquaSKKInput/MacAnnotator.h>
#import <AquaSKKInput/MacCandidateWindow.h>
#import <AquaSKKInput/MacClipboard.h>
#import <AquaSKKInput/MacConfig.h>
#import <AquaSKKInput/MacDynamicCompletor.h>
#import <AquaSKKInput/MacFrontEnd.h>
#import <AquaSKKInput/MacMessenger.h>

#import <AquaSKKTesting/MockAnnotator.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockClipboard.h>
#import <AquaSKKTesting/MockDynamicCompletor.h>
#import <AquaSKKTesting/MockMessenger.h>

TyperInputSessionParameter::TyperInputSessionParameter(id client)
    : config_(new MacConfig()),
      frontend_(new MacFrontEnd(client)),
      messenger_(new MockMessenger()),
      clipboard_(new MockClipboard()),
      candidateWindow_(new MockCandidateWindow()),
      annotator_(new MockAnnotator()),
      completor_(new MockDynamicCompletor()) {}

SKKConfig *TyperInputSessionParameter::Config() {
    return config_.get();
}

SKKFrontEnd *TyperInputSessionParameter::FrontEnd() {
    return frontend_.get();
}

SKKMessenger *TyperInputSessionParameter::Messenger() {
    return messenger_.get();
}

SKKClipboard *TyperInputSessionParameter::Clipboard() {
    return clipboard_.get();
}

SKKCandidateWindow *TyperInputSessionParameter::CandidateWindow() {
    return candidateWindow_.get();
}

SKKAnnotator *TyperInputSessionParameter::Annotator() {
    return annotator_.get();
}

SKKDynamicCompletor *TyperInputSessionParameter::DynamicCompletor() {
    return completor_.get();
}
