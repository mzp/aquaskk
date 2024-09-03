#ifndef MockCandidateWindow_h
#define MockCandidateWindow_h

#include <vector>
#import <AquaSKKCore/SKKCandidateWindow.h>

class MockCandidateWindow : public SKKCandidateWindow {
    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();
    std::vector<SKKCandidate> container_;

public:
    virtual void Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages);
    virtual void Update(SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max);
    virtual int LabelIndex(char label);
    std::vector<SKKCandidate> Container() const {
        return container_;
    }
};

#endif
