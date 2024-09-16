/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A C++ class that requires reference-counting semantics should
  derive from this C++ class.
*/

#pragma once

template <class T> class IntrusiveRefCounted {
public:
    IntrusiveRefCounted()
        : referenceCount(1) {}

    IntrusiveRefCounted(const IntrusiveRefCounted &) = delete;

    void retain() {
        ++referenceCount;
    }

    void release() {
        --referenceCount;
        if(referenceCount == 0) {
            delete static_cast<T *>(this);
        }
    }

private:
    int referenceCount;
};
