//
//  SKKAnnotatorAdapter.hpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

#ifndef SKKAnnotatorAdapter_hpp
#define SKKAnnotatorAdapter_hpp

#import <Foundation/Foundation.h>
#include <AquaSKKEngine/SKKAnnotator.h>

@protocol SKKAnnotatorProtocol;

class SKKAnnotatorAdapter : public SKKAnnotator {
    id<SKKAnnotatorProtocol> impl_;

public:
    SKKAnnotatorAdapter(id<SKKAnnotatorProtocol> impl);
    ~SKKAnnotatorAdapter();

    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();

    virtual void Update(const SKKCandidate &candidate, int cursorOffset);
};

#endif /* SKKAnnotatorAdapter_hpp */
