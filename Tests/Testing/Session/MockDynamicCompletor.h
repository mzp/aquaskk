// -*- C++ -*-

#ifndef MockDynamicCompletor_h
#define MockDynamicCompletor_h

#import <AquaSKKCore/SKKDynamicCompletor.h>

class MockDynamicCompletor : public SKKDynamicCompletor {
private:
    std::string completion_;
    int commonPrefixSize_;
    int cursorOffset_;
    bool visible_;

public:
    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();
    virtual void Update(const std::string &completion, int commonPrefixSize, int cursorOffset);

    std::string GetCompletion();
    int GetCommonPrefixSize();
    int GetCursorOffset();
    bool IsVisible();
};

#endif
