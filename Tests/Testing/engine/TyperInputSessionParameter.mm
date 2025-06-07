//
//  TyperInputSessionParameter.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "TyperInputSessionParameter.h"
#import <AquaSKKEngine/AquaSKKEngine.h>

SKKInputSessionParameter *TyperInputSessionParameter::Coerce(id<SKKInputSessionParameterProtocol> params) {
    return new SKKInputSessionParameterAdapter(params);
}
