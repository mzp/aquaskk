//
//  SKKAnnotatorBridge.hpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

#ifndef SKKAnnotatorBridge_hpp
#define SKKAnnotatorBridge_hpp

#import <Foundation/Foundation.h>
#include <AquaSKKEngine/SKKAnnotator.h>

@protocol SKKAnnotatorProtocol;

class SKKAnnotatorBridge : public SKKAnnotator {
    id<SKKAnnotatorProtocol> impl_;
public:
    SKKAnnotatorBridge(id<SKKAnnotatorProtocol> impl);
    ~SKKAnnotatorBridge();

    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();

    virtual void Update(const SKKCandidate &candidate, int cursorOffset);
};

#endif /* SKKAnnotatorBridge_hpp */
