// -*- C++ -*-

#ifndef MockCompletionHelper_h
#define MockCompletionHelper_h

#include <vector>
#include <swift/bridging>
#import <AquaSKKBackend/SKKCompletionHelper.h>
#import <AquaSKKBackend/IntrusiveRefCounted.h>

class MockCompletionHelper : public SKKCompletionHelper , public IntrusiveRefCounted<MockCompletionHelper> {
    std::vector<std::string> result_;
    std::string entry_;

public:
    void Initialize(const std::string &entry);

    std::vector<std::string> Result();

    const std::string &Entry() const;

    void Add(const std::string &completion);

    bool CanContinue() const;

    static MockCompletionHelper* _Nonnull newInstance() {
        return new MockCompletionHelper();
    }
} SWIFT_SHARED_REFERENCE(SKKRetain, SKKRelease);

void SKKRetain(MockCompletionHelper *_Nonnull param);

void SKKRelease(MockCompletionHelper *_Nonnull param);


#endif
