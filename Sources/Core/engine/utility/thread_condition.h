//
//  pthread_condition.h
//  AquaSKK
//
//  Created by mzp on 9/7/24.
//

#ifndef pthread_condition_h
#define pthread_condition_h

#include <Foundation/Foundation.h>

namespace pthread {
    class condition {
        NSCondition *condition_;

    public:
        condition();
        ~condition();

        void signal();
        void broadcast();
        bool wait();
        bool wait(long second);

        void lock();
        void unlock();
    };
} // namespace pthread

#endif /* pthread_condition_h */
