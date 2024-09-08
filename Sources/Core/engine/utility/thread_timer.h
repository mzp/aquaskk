//
//  timer.h
//  AquaSKK
//
//  Created by mzp on 9/7/24.
//

#ifndef timer_h
#define timer_h

#import <Foundation/Foundation.h>

namespace pthread {
    class task {
    public:
        virtual ~task() {}
        virtual bool run() = 0;
    };

    class timer {
        NSTimer *timer_;

    public:
        static NSRunLoop *runLoop();
        timer(task *task, long interval, long startup_delay = 0);
        ~timer();
    };
} // namespace pthread
#endif /* timer_h */
