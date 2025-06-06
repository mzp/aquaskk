//
//  TyperInputSessionParameter.hpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#ifndef TyperInputSessionParameter_hpp
#define TyperInputSessionParameter_hpp

class SKKInputSessionParameter;
@protocol SKKInputSessionParameterProtocol;

class TyperInputSessionParameter {
public:
    static SKKInputSessionParameter *_Nonnull Coerce(id<SKKInputSessionParameterProtocol> params);
};

#endif /* TyperInputSessionParameter_hpp */
