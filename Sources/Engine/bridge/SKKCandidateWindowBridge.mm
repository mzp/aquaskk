//
//  SKKCandidateWindowBridge.m
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#import "SKKCandidateWindowBridge.h"
#import <AquaSKKEngine/SKKCandidateWindow.h>

@implementation SKKCandidateWindowBridge

- (instancetype)initWithImpl:(SKKCandidateWindow *)impl
{
    self = [super init];
    if (self) {
        impl_ = impl;
    }
    return self;
}

- (void)dealloc
{
}

- (NSInteger)labelIndexOf:(NSInteger)label {
    return impl_->LabelIndex(label);
}

- (NSArray<NSNumber *> * _Nonnull)setupWithCandidates:(NSArray<NSString *> * _Nonnull)candidates {
    SKKCandidateContainer container;
    for (NSString *candidate in candidates) {
        container.push_back(SKKCandidate(candidate.UTF8String));
    }
    std::vector<int> pages;
    impl_->Setup(container.begin(), container.end(), pages);

    NSMutableArray<NSNumber *> *result = [NSMutableArray array];
    for (int page : pages) {
        [result addObject:@(page)];
    }
    return result;
}

- (void)show {
    impl_->Show();
}

- (void)hide {
    impl_->Hide();
}

- (void)updateWithCandidates:(NSArray<NSString *> * _Nonnull)candidates cursor:(NSInteger)cursor position:(NSInteger)position max:(NSInteger)max {
    SKKCandidateContainer container;
    for (NSString *candidate in candidates) {
        container.push_back(SKKCandidate(candidate.UTF8String));
    }
    impl_->Update(container.begin(), container.end(), static_cast<int>(cursor), static_cast<int>(position), static_cast<int>(max));
}

@end
