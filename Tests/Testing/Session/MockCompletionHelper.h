// -*- C++ -*-

#ifndef MockCompletionHelper_h
#define MockCompletionHelper_h

#include <vector>
#import <AquaSKKCore/SKKCompletionHelper.h>

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
