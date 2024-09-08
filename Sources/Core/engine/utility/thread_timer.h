//
//  timer.h
//  AquaSKK
//
//  Created by mzp on 9/7/24.
//

#ifndef timer_h
#define timer_h

#import <Foundation/Foundation.h>
#include <pthread.h>

namespace pthread {
    class task {
    public:
        virtual ~task() {}
        virtual bool run() = 0;
    };

    class timer {
        task *task_;
        long interval_;
        long startup_delay_;
        pthread_t thread_;

        static void *handler(void *param);

        void run();

        void wait(long second);

        timer();
        timer(const timer &);
        timer &operator=(const timer &);

    public:
        timer(task *task, long interval, long startup_delay = 0);
        ~timer();
    };
} // namespace pthread
#endif /* timer_h */
