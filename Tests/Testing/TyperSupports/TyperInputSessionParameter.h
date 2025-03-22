//
//  TyperInputSessionParameter.hpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#ifndef TyperInputSessionParameter_hpp
#define TyperInputSessionParameter_hpp

#include <memory>
#include <swift/bridging>
#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKAnnotator.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKClipboard.h>
#import <AquaSKKEngine/SKKConfig.h>
#import <AquaSKKEngine/SKKDynamicCompletor.h>
#import <AquaSKKEngine/SKKFrontEnd.h>
#import <AquaSKKEngine/SKKInputSessionParameter.h>
#import <AquaSKKEngine/SKKMessenger.h>
class TyperConfig;

class TyperInputSessionParameter : public SKKInputSessionParameter {
    std::unique_ptr<SKKConfig> config_;
    std::unique_ptr<SKKFrontEnd> frontend_;
    std::unique_ptr<SKKMessenger> messenger_;
    std::unique_ptr<SKKClipboard> clipboard_;
    std::unique_ptr<SKKCandidateWindow> candidateWindow_;
    std::unique_ptr<SKKAnnotator> annotator_;
    std::unique_ptr<SKKDynamicCompletor> completor_;

public:
    TyperInputSessionParameter(id _Nonnull client, TyperConfig *_Nonnull config);
    virtual SKKConfig *_Nonnull Config() SWIFT_RETURNS_RETAINED;
    virtual SKKFrontEnd *_Nonnull FrontEnd() SWIFT_RETURNS_RETAINED;
    virtual SKKMessenger *_Nonnull Messenger() SWIFT_RETURNS_RETAINED;
    virtual SKKClipboard *_Nonnull Clipboard();
    virtual SKKCandidateWindow *_Nonnull CandidateWindow() SWIFT_RETURNS_RETAINED;
    virtual SKKAnnotator *_Nonnull Annotator() SWIFT_RETURNS_RETAINED;
    virtual SKKDynamicCompletor *_Nonnull DynamicCompletor() SWIFT_RETURNS_RETAINED;

    void SetString(std::string pasteString);
    std::vector<std::string> Candidates();
    int GetCandidateCursor();
    int GetCandidatePage();

    std::string GetCompletion();
    int GetCommonPrefixSize();
    int GetCursorOffset();
    bool IsCompletionVisible();

    SKKCandidate GetAnnotation();
    int GetAnnotationCursor();
    bool IsAnnotationVisible();

    static TyperInputSessionParameter *_Nonnull Create(id _Nonnull client, TyperConfig *_Nonnull config);
    static SKKInputSessionParameter *_Nonnull Coerce(TyperInputSessionParameter *_Nonnull params);
} SWIFT_SHARED_REFERENCE(TISRetain, TISRelease);

void TISRetain(TyperInputSessionParameter *_Nonnull params);

void TISRelease(TyperInputSessionParameter *_Nonnull params);

#endif /* TyperInputSessionParameter_hpp */
