//
//  pthreadutil.m
//  AquaSKKCore
//
//  Created by mzp on 9/7/24.
//

#import "thread_timer.h"

NSRunLoop *pthread::timer::runLoop() {
    return [NSRunLoop mainRunLoop];
}

pthread::timer::timer(task *task, long interval, long startup_delay) {
    NSDate *date = [[NSDate alloc] init];
    timer_ = [[NSTimer alloc] initWithFireDate:date
                                      interval:interval
                                       repeats:YES
                                         block:^(NSTimer *timer) {
                                           task->run();
                                         }];
    [runLoop() addTimer:timer_ forMode:NSDefaultRunLoopMode];
}

pthread::timer::~timer() {
    [timer_ invalidate];
}
