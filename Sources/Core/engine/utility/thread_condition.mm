//
//  condition.cpp
//  AquaSKKCore
//
//  Created by mzp on 9/7/24.
//

#include "thread_condition.h"

#include <cassert>
#include <cerrno>
#include <cstdio>
#include <iostream>

pthread::condition::condition() {
    condition_ = [[NSCondition alloc] init];
}

pthread::condition::~condition() {}

void pthread::condition::lock() {
    [condition_ lock];
}

void pthread::condition::unlock() {
    [condition_ unlock];
}

void pthread::condition::signal() {
    [condition_ signal];
}

void pthread::condition::broadcast() {
    [condition_ broadcast];
}

bool pthread::condition::wait() {
    [condition_ wait];
    return true;
}

bool pthread::condition::wait(long second) {
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:second];
    return [condition_ waitUntilDate:date];
}
