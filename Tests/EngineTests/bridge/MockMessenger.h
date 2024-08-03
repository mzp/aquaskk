// -*- C++ -*-

#ifndef MockMessenger_h
#define MockMessenger_h

#import <AquaSKKEngine/SKKMessenger.h>

class MockMessenger : public SKKMessenger {
    virtual void SendMessage(const std::string& msg) {}
    virtual void Beep() {}
};

#endif
