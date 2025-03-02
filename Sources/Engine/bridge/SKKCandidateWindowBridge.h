//
//  SKKCandidateWindowBridge.h
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKKCandidateWindowBridge : NSObject<SKKCandidateWindowPresenter> {
    SKKCandidateWindow *impl_;
}

- (instancetype)initWithImpl:(SKKCandidateWindow *)impl;

@end

NS_ASSUME_NONNULL_END
