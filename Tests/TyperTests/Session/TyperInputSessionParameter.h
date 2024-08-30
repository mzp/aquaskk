//
//  TyperInputSessionParameter.hpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#ifndef TyperInputSessionParameter_hpp
#define TyperInputSessionParameter_hpp

#import <AquaSKKCore/SKKInputSessionParameter.h>
#include <memory>

class TyperInputSessionParameter : public SKKInputSessionParameter {
    std::unique_ptr<SKKConfig> config_;
    std::unique_ptr<SKKFrontEnd> frontend_;
    std::unique_ptr<SKKMessenger> messenger_;
    std::unique_ptr<SKKClipboard> clipboard_;
    std::unique_ptr<SKKCandidateWindow> candidateWindow_;
    std::unique_ptr<SKKAnnotator> annotator_;
    std::unique_ptr<SKKDynamicCompletor> completor_;

public:
    TyperInputSessionParameter(id client);

    virtual SKKConfig *Config();
    virtual SKKFrontEnd *FrontEnd();
    virtual SKKMessenger *Messenger();
    virtual SKKClipboard *Clipboard();
    virtual SKKCandidateWindow *CandidateWindow();
    virtual SKKAnnotator *Annotator();
    virtual SKKDynamicCompletor *DynamicCompletor();

    static TyperInputSessionParameter *newInstance(id client);
    SKKInputSessionParameter *staticCast();
};

#endif /* TyperInputSessionParameter_hpp */
