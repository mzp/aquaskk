//
//  TyperInputSessionParameter.hpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#ifndef TyperInputSessionParameter_hpp
#define TyperInputSessionParameter_hpp

#include <memory>

#import <AquaSKKCore/SKKAnnotator.h>
#import <AquaSKKCore/SKKCandidateWindow.h>
#import <AquaSKKCore/SKKClipboard.h>
#import <AquaSKKCore/SKKConfig.h>
#import <AquaSKKCore/SKKDynamicCompletor.h>
#import <AquaSKKCore/SKKFrontEnd.h>
#import <AquaSKKCore/SKKInputSessionParameter.h>
#import <AquaSKKCore/SKKMessenger.h>

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
};

#endif /* TyperInputSessionParameter_hpp */
