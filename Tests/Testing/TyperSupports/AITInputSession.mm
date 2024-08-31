//
//  AITInputSessionParameter.m
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#import "AITInputSession.h"

#import <AquaSKKInput/SKKInputController_Private.h>
#import <AquaSKKTesting/MockAnnotator.h>
#import <AquaSKKTesting/MockCandidateWindow.h>
#import <AquaSKKTesting/MockClipboard.h>
#import <AquaSKKTesting/MockDynamicCompletor.h>
#import <AquaSKKTesting/MockMessenger.h>

@implementation AITInputSession

- (instancetype)initWithClient:(id)client {
    self = [super init];
    if(self) {
        client_ = client;
        inputSessionParameter_ = new TyperInputSessionParameter(client);
    }
    return self;
}

- (void)setup:(SKKInputController *)inputController {
    // inputSessionParameter_はstd::unique_ptrで管理するので、所有権が移る
    [inputController _setClient:client_ sessionParameter:inputSessionParameter_];
}

- (void)setPasteString:(NSString *)pasteString {
    MockClipboard *clipboard = dynamic_cast<MockClipboard *>(inputSessionParameter_->Clipboard());
    clipboard->SetString(std::string([pasteString UTF8String]));
}

@end
