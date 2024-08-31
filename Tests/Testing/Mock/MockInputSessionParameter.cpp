//
//  MockInputSessionParameter.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockInputSessionParameter.h"

MockInputSessionParameter::MockInputSessionParameter()
    : frontend_(new MockFrontEnd()) {}

SKKConfig *MockInputSessionParameter::Config() {
    return &config_;
}
SKKFrontEnd *MockInputSessionParameter::FrontEnd() {
    return frontend_;
}
SKKMessenger *MockInputSessionParameter::Messenger() {
    return &messenger_;
}
SKKClipboard *MockInputSessionParameter::Clipboard() {
    return &clipboard_;
}
SKKCandidateWindow *MockInputSessionParameter::CandidateWindow() {
    return &candidate_;
}
SKKAnnotator *MockInputSessionParameter::Annotator() {
    return &annotator_;
}
SKKDynamicCompletor *MockInputSessionParameter::DynamicCompletor() {
    return &completor_;
}

SKKInputModeListener *MockInputSessionParameter::Listener() {
    return frontend_;
}
TestResult &MockInputSessionParameter::Result() {
    return *frontend_;
}
void MockInputSessionParameter::SetSelectedString(const std::string &str) {
    frontend_->SetSelectedString(str);
}
void MockInputSessionParameter::SetYankString(const std::string &str) {
    clipboard_.SetString(str);
}

SKKInputSessionParameter *MockInputSessionParameter::newInstance() {
    return new MockInputSessionParameter();
}
