// -*- C++ -*-

#ifndef MockAnnotator_h
#define MockAnnotator_h

#import <AquaSKKEngine/SKKAnnotator.h>

class MockAnnotator : public SKKAnnotator {
    virtual void SKKWidgetShow() {}
    virtual void SKKWidgetHide() {}
    virtual void Update(const SKKCandidate& candidate, int cursor) {}
};

#endif
