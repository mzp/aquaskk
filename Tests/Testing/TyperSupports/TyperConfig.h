// -*- C++ -*-

#ifndef TyperConfig_h
#define TyperConfig_h

#import <AquaSKKEngine/SKKConfig.h>

class TyperConfig : public SKKConfig {
private:
    bool intermediateConversion_;
    bool enableDynamicCompletion_;
    int dynamicCompletionRange_;
    bool enableAnnotation_;
    bool displayShortestMatchOfKanaConversions_;
    bool suppressNewlineOnCommit_;
    int maxCountOfInlineCandidates_;
    bool handleRecursiveEntryAsOkuri_;
    bool inlineBackSpaceImpliesCommit_;
    bool deleteOkuriWhenQuit_;

public:
    TyperConfig();
    TyperConfig(const TyperConfig &other);
    virtual ~TyperConfig();

    virtual bool FixIntermediateConversion();
    void SetFixIntermediateConversion(bool value);
    virtual bool EnableDynamicCompletion();
    void SetEnableDynamicCompletion(bool value);
    virtual int DynamicCompletionRange();
    void SetDynamicCompletionRange(int value);
    virtual bool EnableAnnotation();
    void SetEnableAnnotation(bool value);
    virtual bool DisplayShortestMatchOfKanaConversions();
    void SetDisplayShortestMatchOfKanaConversions(bool value);
    virtual bool SuppressNewlineOnCommit();
    void SetSuppressNewlineOnCommit(bool value);
    virtual int MaxCountOfInlineCandidates();
    void SetMaxCountOfInlineCandidates(int value);
    virtual bool HandleRecursiveEntryAsOkuri();
    void SetHandleRecursiveEntryAsOkuri(bool value);
    virtual bool InlineBackSpaceImpliesCommit();
    void SetInlineBackSpaceImpliesCommit(bool value);
    virtual bool DeleteOkuriWhenQuit();
    void SetDeleteOkuriWhenQuit(bool value);

    static TyperConfig *_Nonnull newInstannce() SWIFT_RETURNS_RETAINED;
} SWIFT_SHARED_REFERENCE(retainTyperConfig, releaseTyperConfig);

void retainTyperConfig(TyperConfig *_Nonnull params);

void releaseTyperConfig(TyperConfig *_Nonnull params);

#endif
