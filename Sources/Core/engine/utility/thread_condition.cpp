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

pthread::err::err(const char *msg)
    : msg_(msg) {}

#ifdef DEBUG
void pthread::err::operator()() {
    std::cerr << "ERR: " << msg_ << ": " << std::strerror(errno) << ": errno=" << errno << std::endl;
}
#else
void operator()() {}
#endif

void pthread::suspend_cancel::set(int state) {
    int tmp;
    if(pthread_setcancelstate(state, &tmp) != 0) {
        err("pthread_setcancelstate");
    }
}

pthread::suspend_cancel::suspend_cancel() {
    set(PTHREAD_CANCEL_DISABLE);
}

pthread::suspend_cancel::~suspend_cancel() {
    set(PTHREAD_CANCEL_ENABLE);
}

pthread::mutex::mutex() {
    if(pthread_mutex_init(&handle_, 0) != 0) {
        err("pthread_mutex_init");
    }
};

pthread::mutex::~mutex() {
    if(pthread_mutex_destroy(&handle_) != 0) {
        err("pthread_mutex_destroy");
    }
}

pthread::lock::lock(mutex &target)
    : target_(target) {
    if(pthread_mutex_lock(&target_.handle_) != 0) {
        err("pthread_mutex_lock");
    }
}

pthread::lock::~lock() {
    if(pthread_mutex_unlock(&target_.handle_) != 0) {
        err("pthread_mutex_unlock");
    }
}

void pthread::condition::trylock() {
    assert(
        EBUSY == pthread_mutex_trylock(&mutex_.handle_) &&
        "*** You MUST lock the pthread::condition object to avoid race conditions. ***");
}

pthread::condition::condition() {
    pthread_cond_init(&handle_, 0);
}

pthread::condition::~condition() {
    pthread_cond_destroy(&handle_);
}

pthread::condition::operator pthread::mutex &() {
    return mutex_;
}

void pthread::condition::signal() {
    trylock();

    if(pthread_cond_signal(&handle_) != 0) {
        err("pthread_cond_signal");
    }
}

void pthread::condition::broadcast() {
    trylock();

    if(pthread_cond_broadcast(&handle_) != 0) {
        err("pthread_cond_broadcast");
    }
}

bool pthread::condition::wait() {
    trylock();

    if(pthread_cond_wait(&handle_, &mutex_.handle_) != 0) {
        err("pthread_cond_wait");
        return false;
    }

    return true;
}

bool pthread::condition::wait(long second, long nano_second) {
    trylock();

    timespec abstime;
    abstime.tv_sec = std::time(0) + second;
    abstime.tv_nsec = nano_second;

    if(pthread_cond_timedwait(&handle_, &mutex_.handle_, &abstime) != 0) {
        err("pthread_cond_timedwait");
        return false;
    }

    return true;
}
