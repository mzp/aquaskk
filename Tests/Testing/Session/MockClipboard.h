// -*- C++ -*-

#ifndef MockClipboard_h
#define MockClipboard_h

#import <AquaSKKEngine/SKKClipboard.h>

class MockClipboard : public SKKClipboard {
    std::string str_;

    virtual const std::string PasteString();

public:
    void SetString(const std::string &str);
};

#endif
