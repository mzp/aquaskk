// -*- C++ -*-

#ifndef MockInputSessionParameter_h
#define MockInputSessionParameter_h

#import <AquaSKKCore/SKKInputSessionParameter.h>
#import <AquaSKKTesting/MockAnnotator.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockClipboard.h>
#import <AquaSKKTesting/MockConfig.h>
#import <AquaSKKTesting/MockDynamicCompletor.h>
#import <AquaSKKTesting/MockFrontEnd.h>
#import <AquaSKKTesting/MockMessenger.h>

class MockInputSessionParameter : public SKKInputSessionParameter {
    MockConfig config_;
    MockFrontEnd *frontend_;
    MockMessenger messenger_;
    MockClipboard clipboard_;
    MockCandidateWindow candidate_;
    MockAnnotator annotator_;
    MockDynamicCompletor completor_;

public:
    MockInputSessionParameter();
    virtual SKKConfig *Config();
    virtual SKKFrontEnd *FrontEnd();
    virtual SKKMessenger *Messenger();
    virtual SKKClipboard *Clipboard();
    virtual SKKCandidateWindow *CandidateWindow();
    virtual SKKAnnotator *Annotator();
    virtual SKKDynamicCompletor *DynamicCompletor();
    SKKInputModeListener *Listener();
    TestResult &Result();
    void SetSelectedString(const std::string &str);
    void SetYankString(const std::string &str);
    static SKKInputSessionParameter *newInstance();
};

#endif
