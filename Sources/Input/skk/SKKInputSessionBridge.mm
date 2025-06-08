//
//  SKKInputSessionBridge.m
//  AquaSKKInput
//
//  Created by mzp on 2/13/25.
//

#import "SKKInputSessionBridge.h"
#import <AquaSKKEngine/AquaSKKEngine.h>
#import <AquaSKKInput/AquaSKKInput-Preamble.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>

@interface SKKInputSessionBridge () {
    SKKInputSession *impl;
}
@end

@implementation SKKInputSessionBridge

- (instancetype)initWithClient:(id)client layoutManager:(SKKLayoutManager *)layoutManager;
{
    MacInputSessionParameterImpl *parameter = [[MacInputSessionParameterImpl alloc] initWithClient:client
                                                                                     layoutManager:layoutManager];
    return [self initWithParameter:parameter];
}

- (instancetype)initWithParameter:(id<SKKInputSessionParameterProtocol>)parameter {
    self = [super init];
    if(self) {
        impl = new SKKInputSession(parameter);
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

- (void)addListenerWithInputModeMenuImpl:(MacInputModeMenuImpl *)menu {
    impl->AddInputModeListener(menu);
}

- (void)addListenerWithInputModeWindowImpl:(MacInputModeWindowImpl *)window {
    [window skkWidgetShow];
    impl->AddInputModeListener(window);
}
@end
