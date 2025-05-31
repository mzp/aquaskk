//
//  TestInputQueueObserver.cpp
//  AquaSKK
//
//  Created by mzp on 2025/05/30.
//

#include "TestInputQueueObserver.h"
#import <AquaSKKTesting/AquaSKKTesting-Swift.h>

class TestInputQueueObserverContainer {
public:
    AquaSKKTesting::TestInputQueueObserverImpl impl_;

    TestInputQueueObserverContainer()
        : impl_(AquaSKKTesting::TestInputQueueObserverImpl::init()) {}
};

TestInputQueueObserver *TestInputQueueObserver::createInstance() {
    return new TestInputQueueObserver();
}

TestInputQueueObserver::TestInputQueueObserver()
    : container(new TestInputQueueObserverContainer()) {}

TestInputQueueObserver::~TestInputQueueObserver() {
    delete container;
}

void TestInputQueueObserver::SKKInputQueueUpdate(const SKKInputQueueObserverState &state) {
    container->impl_.bridgeInputQueueUpdate(state.fixed, state.intermediate, state.queue, state.code);
}

void TestInputQueueObserver::Clear() {
    container->impl_.clear();
}

bool TestInputQueueObserver::Test(const std::string &fixed, const std::string &queue) {
    return container->impl_.isEqual(fixed, queue);
}

void TestInputQueueObserver::Dump() {
    std::cerr << (container->impl_.getDescription()) << std::endl;
}

id<SKKInputQueueObserverProtocol> TestInputQueueObserver::getInputQueueObserverProtocol() {
    return container->impl_.getInputQueueObserverProtocol();
}
