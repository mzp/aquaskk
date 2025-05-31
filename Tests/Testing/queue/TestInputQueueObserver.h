//
//  TestInputQueueObserver.hpp
//  AquaSKK
//
//  Created by mzp on 2025/05/30.
//

#ifndef TestInputQueueObserver_hpp
#define TestInputQueueObserver_hpp

#include <cassert>
#include <iostream>
#import <AquaSKKEngine/AquaSKKEngine.h>
#include <stdio.h>

class TestInputQueueObserverContainer;
class TestInputQueueObserver : public SKKInputQueueObserver {
    TestInputQueueObserverContainer *container;

public:
    TestInputQueueObserver();
    virtual ~TestInputQueueObserver();
    id<SKKInputQueueObserverProtocol> getInputQueueObserverProtocol() override;
    virtual void SKKInputQueueUpdate(const SKKInputQueueObserverState &state);
    void Clear();
    bool Test(const std::string &fixed, const std::string &queue);
    void Dump();

    static TestInputQueueObserver *createInstance();
};

class TestInputQueueObserver2 {
public:
    static void func() {};
};

#endif /* TestInputQueueObserver_hpp */
