//
//  pthread_condition.h
//  AquaSKK
//
//  Created by mzp on 9/7/24.
//

#ifndef pthread_condition_h
#define pthread_condition_h

#include <pthread.h>

namespace pthread {
    class err {
        const char *msg_;

    public:
        err(const char *msg);
        void operator()();
    };

    class suspend_cancel {
        void set(int state);
        suspend_cancel(const suspend_cancel &);
        suspend_cancel &operator=(const suspend_cancel &);

    public:
        suspend_cancel();
        ~suspend_cancel();
    };

    class mutex {
        friend class lock;
        friend class condition;

        pthread_mutex_t handle_;

        mutex(const mutex &);
        mutex &operator=(const mutex &);

    public:
        mutex();
        ~mutex();
    };

    class lock {
        suspend_cancel shield_;
        mutex &target_;

        lock();
        lock(const lock &);
        lock &operator=(const lock &);

    public:
        lock(mutex &target);
        ~lock();
    };

    class condition {
        mutex mutex_;
        pthread_cond_t handle_;

        condition(const condition &);
        condition &operator=(const condition &);

        void trylock();

    public:
        condition();
        ~condition();
        operator mutex &();
        void signal();
        void broadcast();
        bool wait();
        bool wait(long second, long nano_second = 0);
    };
} // namespace pthread

#endif /* pthread_condition_h */
