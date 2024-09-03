#ifndef MockFrontEnd_h
#define MockFrontEnd_h

#include <sstream>
#include <AquaSKKCore/SKKFrontEnd.h>
#import <AquaSKKCore/SKKInputModeListener.h>
#include <AquaSKKTesting/TestResult.h>

class MockFrontEnd : public SKKFrontEnd, public SKKInputModeListener {
    TestResult result_;
    std::string selected_string_;

    virtual void InsertString(const std::string &str);
    virtual void ComposeString(const std::string &str, int cursorOffset);
    virtual void ComposeString(const std::string &str, int convertFrom, int convertTo);
    virtual std::string SelectedString();
    virtual void SelectInputMode(SKKInputMode mode);
    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();

public:
    void SetSelectedString(const std::string &str);
    operator TestResult &();
};

#endif
