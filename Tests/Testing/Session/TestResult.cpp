//
//  TestResult.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TestResult.h"

TestResult::TestResult()
    : mode(SKKInputMode::InvalidInputMode), pos(0), ret(true) {}

TestResult::TestResult(const std::string &fixed, const std::string &marked, SKKInputMode mode, bool ret, int pos)
    : fixed(fixed), marked(marked), mode(mode), pos(pos), ret(ret) {}

void TestResult::Clear() {
    fixed = marked = "";
    pos = 0;
}

void TestResult::Dump(const std::string &msg) {
    std::cerr << msg << "fixed=" << fixed << ", "
              << "marked=" << marked << ", "
              << "pos=" << pos << ", "
              << "mode=" << (int)mode << ", "
              << "ret=" << ret << ", " << std::endl;
}

bool operator==(const TestResult &left, const TestResult &right) {
    return left.fixed == right.fixed && left.marked == right.marked && left.mode == right.mode &&
           left.pos == right.pos && left.ret == right.ret;
}

bool operator!=(const TestResult &left, const TestResult &right) {
    return !(left == right);
}
