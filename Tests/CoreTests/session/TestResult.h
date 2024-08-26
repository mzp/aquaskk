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

    TestResult()
        : mode(SKKInputMode::InvalidInputMode), pos(0), ret(true) {}
    TestResult(
        const std::string &fixed, const std::string &marked, SKKInputMode mode = SKKInputMode::InvalidInputMode,
        bool ret = true, int pos = 0)
        : fixed(fixed), marked(marked), mode(mode), pos(pos), ret(ret) {}

    void Clear() {
        fixed = marked = "";
        pos = 0;
    }

    void Dump(const std::string &msg) {
        std::cerr << msg << "fixed=" << fixed << ", "
                  << "marked=" << marked << ", "
                  << "pos=" << pos << ", "
                  << "mode=" << (int)mode << ", "
                  << "ret=" << ret << ", " << std::endl;
    }

    friend bool operator==(const TestResult &left, const TestResult &right) {
        return left.fixed == right.fixed && left.marked == right.marked && left.mode == right.mode &&
               left.pos == right.pos && left.ret == right.ret;
    }

    friend bool operator!=(const TestResult &left, const TestResult &right) {
        return !(left == right);
    }
};

#endif
