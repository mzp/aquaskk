//
//  AITInputSessionParameter.h
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#import <AquaSKKInput/SKKInputController.h>
#import <AquaSKKTesting/TyperInputSessionParameter.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AITInputSession : NSObject {
    TyperInputSessionParameter *inputSessionParameter_;
    id client_;
}

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClient:(id)client NS_DESIGNATED_INITIALIZER;

- (void)setup:(SKKInputController *)inputController;
- (void)setPasteString:(NSString *)pasteString NS_SWIFT_NAME(set(pasteString:));

@end

NS_ASSUME_NONNULL_END
