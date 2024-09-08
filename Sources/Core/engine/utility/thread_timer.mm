//
//  pthreadutil.m
//  AquaSKKCore
//
//  Created by mzp on 9/7/24.
//

#import "thread_timer.h"

void *pthread::timer::handler(void *param) {
    timer *self = reinterpret_cast<timer *>(param);

    self->run();

    return 0;
}

void pthread::timer::run() {
    wait(startup_delay_);

    while(task_->run()) {
        wait(interval_);
    }
}

void pthread::timer::wait(long second) {
    if(!second)
        return;

    timespec ts;
    ts.tv_sec = second;
    ts.tv_nsec = 0;

    nanosleep(&ts, 0);
}

pthread::timer::timer(task *task, long interval, long startup_delay)
    : task_(task), interval_(interval), startup_delay_(startup_delay) {
    if(pthread_create(&thread_, 0, timer::handler, this) != 0) {
        thread_ = 0;
    }
}

pthread::timer::~timer() {
    if(thread_ && pthread_cancel(thread_) == 0) {
        pthread_join(thread_, 0);
    }
}
