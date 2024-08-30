// -*- C++ -*-

#ifndef MockCompletionHelper_h
#define MockCompletionHelper_h

#import <AquaSKKCore/SKKCompletionHelper.h>
#include <vector>

class MockCompletionHelper : public SKKCompletionHelper {
    std::vector<std::string> result_;
    std::string entry_;

public:
    void Initialize(const std::string &entry);

    std::vector<std::string> &Result();

    const std::string &Entry() const;

    void Add(const std::string &completion);

    bool CanContinue() const;
};

#endif
