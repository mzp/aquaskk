//
//  SKKInputController_Private.h
//  AquaSKK
//
//  Created by mzp on 8/3/24.
//

#ifndef SKKInputController_Private_h
#define SKKInputController_Private_h

#import <AquaSKKCore/SKKInputSessionParameter.h>
#import <AquaSKKInput/SKKInputController.h>

@interface SKKInputController (Testing)

/// Setup InputController without IMK connection. Testing only.
- (void)_setClient:(id)client;

- (void)_setClient:(id)client sessionParameter:(SKKInputSessionParameter *)parameter;
@end

#endif /* SKKInputController_Private_h */
