//
//  SwiftObject.h
//  AquaSKK
//
//  Created by mzp on 9/28/24.
//

#ifndef SwiftObject_h
#define SwiftObject_h

template <class T> class SwiftObject {
    T impl_;

public:
    SwiftObject()
        : impl_(T::init()) {}

    template <class P1> SwiftObject(P1 p1): impl_(T::init(p1)) {}
    template <class P1, class P2> SwiftObject(P1 p1, P2 p2): impl_(T::init(p1, p2)) {}


    T *operator->() {
        return &impl_;
    }
};

#endif /* SwiftObject_h */
