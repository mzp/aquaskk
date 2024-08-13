//
//  SKKInputController_Private.h
//  AquaSKK
//
//  Created by mzp on 8/3/24.
//

#ifndef SKKInputController_Private_h
#define SKKInputController_Private_h

#import <AquaSKKIM/SKKInputController.h>

@interface SKKInputController (Testing)

/// Setup InputController without IMK connection. Testing only.
- (void)_setClient:(id)client;
@end

#endif /* SKKInputController_Private_h */
