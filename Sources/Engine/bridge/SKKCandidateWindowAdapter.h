//
//  SKKCandidateWindowAdapter.hpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

#ifndef SKKCandidateWindowAdapter_hpp
#define SKKCandidateWindowAdapter_hpp

#import <Foundation/Foundation.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>

@protocol SKKCandidateWindowProtocol;

class SKKCandidateWindowAdapter : public SKKCandidateWindow {
    id<SKKCandidateWindowProtocol> impl_;
    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();

public:
    SKKCandidateWindowAdapter(id<SKKCandidateWindowProtocol> impl);
    virtual ~SKKCandidateWindowAdapter();

    virtual void Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages);
    virtual void Update(SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max);
    virtual int LabelIndex(char label);
};

#endif /* SKKCandidateWindowAdapter_hpp */
