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
    T *operator->() {
        return &impl_;
    }
};

#endif /* SwiftObject_h */
