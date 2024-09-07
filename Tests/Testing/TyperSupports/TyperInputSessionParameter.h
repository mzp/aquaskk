//
//  TyperInputSessionParameter.hpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#ifndef TyperInputSessionParameter_hpp
#define TyperInputSessionParameter_hpp

#import <AquaSKKCore/IntrusiveRefCounted.h>
#import <AquaSKKCore/SKKAnnotator.h>
#import <AquaSKKCore/SKKCandidateWindow.h>
#import <AquaSKKCore/SKKClipboard.h>
#import <AquaSKKCore/SKKConfig.h>
#import <AquaSKKCore/SKKDynamicCompletor.h>
#import <AquaSKKCore/SKKFrontEnd.h>
#import <AquaSKKCore/SKKInputSessionParameter.h>
#import <AquaSKKCore/SKKMessenger.h>
#include <memory>
#include <swift/bridging>

class TyperInputSessionParameter : public SKKInputSessionParameter {
    std::unique_ptr<SKKConfig> config_;
    std::unique_ptr<SKKFrontEnd> frontend_;
    std::unique_ptr<SKKMessenger> messenger_;
    std::unique_ptr<SKKClipboard> clipboard_;
    std::unique_ptr<SKKCandidateWindow> candidateWindow_;
    std::unique_ptr<SKKAnnotator> annotator_;
    std::unique_ptr<SKKDynamicCompletor> completor_;

public:
    TyperInputSessionParameter(id _Nonnull client);
    virtual SKKConfig *_Nonnull Config();
    virtual SKKFrontEnd *_Nonnull FrontEnd();
    virtual SKKMessenger *_Nonnull Messenger();
    virtual SKKClipboard *_Nonnull Clipboard();
    virtual SKKCandidateWindow *_Nonnull CandidateWindow();
    virtual SKKAnnotator *_Nonnull Annotator();
    virtual SKKDynamicCompletor *_Nonnull DynamicCompletor();

    void SetString(std::string pasteString);
    std::vector<std::string> Candidates();

    std::string GetCompletion();
    int GetCommonPrefixSize();
    int GetCursorOffset();
    bool IsCompletionVisible();

    SKKCandidate GetAnnotation();
    int GetAnnotationCursor();
    bool IsAnnotationVisible();

    static TyperInputSessionParameter *_Nonnull Create(id _Nonnull client);
    static SKKInputSessionParameter *_Nonnull Coerce(TyperInputSessionParameter *_Nonnull params);
} SWIFT_SHARED_REFERENCE(TISRetain, TISRelease);

void TISRetain(TyperInputSessionParameter *_Nonnull params);

void TISRelease(TyperInputSessionParameter *_Nonnull params);

#endif /* TyperInputSessionParameter_hpp */
