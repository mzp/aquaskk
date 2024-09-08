// -*- C++ -*-

#ifndef MockAnnotator_h
#define MockAnnotator_h

#import <AquaSKKCore/SKKAnnotator.h>

class MockAnnotator : public SKKAnnotator {
    SKKCandidate candidate_;
    int cursor_;
    bool visible_;

public:
    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();
    virtual void Update(const SKKCandidate &candidate, int cursor);

    SKKCandidate &GetCandidate();
    int GetCursor();
    bool IsVisible();
};

#endif
