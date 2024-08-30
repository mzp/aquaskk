// -*- C++ -*-

#ifndef MockInputSessionParameter_h
#define MockInputSessionParameter_h

#import <AquaSKKTesting/MockAnnotator.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockClipboard.h>
#import <AquaSKKTesting/MockConfig.h>
#import <AquaSKKTesting/MockDynamicCompletor.h>
#import <AquaSKKTesting/MockFrontEnd.h>
#import <AquaSKKTesting/MockMessenger.h>
#import <AquaSKKCore/SKKInputSessionParameter.h>

class MockInputSessionParameter : public SKKInputSessionParameter {
    MockConfig config_;
    MockFrontEnd *frontend_;
    MockMessenger messenger_;
    MockClipboard clipboard_;
    MockCandidateWindow candidate_;
    MockAnnotator annotator_;
    MockDynamicCompletor completor_;

public:
    MockInputSessionParameter()
        : frontend_(new MockFrontEnd()) {}

    virtual SKKConfig *Config() {
        return &config_;
    }
    virtual SKKFrontEnd *FrontEnd() {
        return frontend_;
    }
    virtual SKKMessenger *Messenger() {
        return &messenger_;
    }
    virtual SKKClipboard *Clipboard() {
        return &clipboard_;
    }
    virtual SKKCandidateWindow *CandidateWindow() {
        return &candidate_;
    }
    virtual SKKAnnotator *Annotator() {
        return &annotator_;
    }
    virtual SKKDynamicCompletor *DynamicCompletor() {
        return &completor_;
    }

    SKKInputModeListener *Listener() {
        return frontend_;
    }
    TestResult &Result() {
        return *frontend_;
    }
    void SetSelectedString(const std::string &str) {
        frontend_->SetSelectedString(str);
    }
    void SetYankString(const std::string &str) {
        clipboard_.SetString(str);
    }
};

#endif
