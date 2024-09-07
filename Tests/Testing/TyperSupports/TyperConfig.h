// -*- C++ -*-

#ifndef MockConfig_h
#define MockConfig_h

#import <AquaSKKCore/SKKConfig.h>

class TyperConfig : public SKKConfig {
private:
    bool dynamicCompletion_;

public:
    virtual bool FixIntermediateConversion();
    virtual bool EnableDynamicCompletion();
    virtual void SetEnableDynamicCompletion(bool value);
    virtual int DynamicCompletionRange();
    virtual bool EnableAnnotation();
    virtual bool DisplayShortestMatchOfKanaConversions();
    virtual bool SuppressNewlineOnCommit();
    virtual int MaxCountOfInlineCandidates();
    virtual bool HandleRecursiveEntryAsOkuri();
    virtual bool InlineBackSpaceImpliesCommit();
    virtual bool DeleteOkuriWhenQuit();
};

#endif
