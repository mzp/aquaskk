//
//  SKKInputSessionBridge.h
//  AquaSKKInput
//
//  Created by mzp on 2/13/25.
//

#import <Foundation/Foundation.h>
#import <AquaSKKEngine/SKKEvent.h>

NS_ASSUME_NONNULL_BEGIN

@class SKKLayoutManager;
class SKKInputSessionParameter;
@class MacInputModeWindowImpl;
@class MacInputModeMenuImpl;
@protocol SKKInputSessionParameterProtocol;

@interface SKKInputSessionBridge : NSObject

- (instancetype)initWithClient:(id)client layoutManager:(SKKLayoutManager *)layoutManager;
- (instancetype)initWithParameter:(id<SKKInputSessionParameterProtocol>)parameter;
- (void)commit;
- (void)activate;
- (void)deactivate;
- (BOOL)handle:(SKKEvent *)event;
- (void)addListenerWithInputModeWindowImpl:(MacInputModeWindowImpl *)window;
- (void)addListenerWithInputModeMenuImpl:(MacInputModeMenuImpl *)menu;
@end

NS_ASSUME_NONNULL_END
