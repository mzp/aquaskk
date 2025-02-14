//
//  SKKInputSessionBridge.m
//  AquaSKKInput
//
//  Created by mzp on 2/13/25.
//

#import "SKKInputSessionBridge.h"
#import <AquaSKKCore/SKKInputSession.h>
#import <AquaSKKInput/MacInputModeMenu.h>
#import <AquaSKKInput/MacInputModeWindow.h>
#import <AquaSKKInput/MacInputSessionParameter.h>

@interface SKKInputSessionBridge () {
    SKKInputSession *impl;
}
@end

@implementation SKKInputSessionBridge

- (instancetype)initWithClient:(id)client layoutManager:(SKKLayoutManager *)layoutManager;
{
    self = [super init];
    if(self) {
        impl = new SKKInputSession(new MacInputSessionParameter(client, layoutManager));
    }
    return self;
}

- (void)dealloc {
    delete impl;
}

- (void)commit {
    impl->Commit();
}

- (void)activate {
    impl->Activate();
}

- (void)deactivate {
    impl->Deactivate();
}

- (BOOL)handle:(SKKEvent *)event {
    return impl->HandleEvent(*event);
}

- (void)addListenerWithInputModeMenu:(MacInputModeMenu *)menu {
    impl->AddInputModeListener(menu);
}

- (void)addListenerWithInputModeWindow:(MacInputModeWindow *)window {
    window->SKKWidgetShow();
    impl->AddInputModeListener(window);
}
@end
