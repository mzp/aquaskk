// -*- C++ -*-

#ifndef TestResult_h
#define TestResult_h

#import <AquaSKKCore/SKKInputMode.h>
#include <iostream>
#include <string>

// SKKInputSession テスト用のテスト結果
struct TestResult {
    std::string fixed;
    std::string marked;
    SKKInputMode mode;
    int pos;
    bool ret;

    TestResult();
    TestResult(
        const std::string &fixed, const std::string &marked, SKKInputMode mode = SKKInputMode::InvalidInputMode,
        bool ret = true, int pos = 0);
    void Clear();

    void Dump(const std::string &msg);

    friend bool operator==(const TestResult &left, const TestResult &right);
    friend bool operator!=(const TestResult &left, const TestResult &right);
};

#endif
