#include "pthreadutil.h"
#include <string>
#include <iostream>
#include <sstream>
#include <unistd.h>

#import <XCTest/XCTest.h>

class debugtask : public pthread::task {
    std::string str_;
    int loop_;
    pthread::mutex& mutex_;

public:
    debugtask(const std::string& str, int loop, pthread::mutex& mutex)
        : str_(str), loop_(loop), mutex_(mutex) {}

    virtual ~debugtask() {
        pthread::lock scope(mutex_);
        std::cerr << "delete: " << str_ << std::endl;
    }
    
    virtual bool run() {
        for(int index = 0; index < loop_; ++ index) {
            do {
                pthread::lock scope(mutex_);
                std::cerr << "run :" << str_ << std::endl;
            } while(0);

            sleep(1);
        }

        return true;
    }
};


@interface PThreadUtilTests : XCTestCase

@end

@implementation PThreadUtilTests

- (void)testMain {
    pthread::pool pool(1);
    pthread::mutex mutex;

    XCTSkip(@"FIXME: Disabled in original code");
    pool.enqueue(new debugtask("1", 3, mutex));
    pool.enqueue(new debugtask("2", 3, mutex));
    pool.enqueue(new debugtask("3", 3, mutex));
    pool.enqueue(new debugtask("4", 3, mutex));
}

@end
