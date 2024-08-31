// -*- C++ -*-

#ifndef MockConfig_h
#define MockConfig_h

#import <AquaSKKCore/SKKConfig.h>

class MockConfig : public SKKConfig {
    virtual bool FixIntermediateConversion();
    virtual bool EnableDynamicCompletion();
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
