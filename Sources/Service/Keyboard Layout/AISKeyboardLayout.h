//
//  AISKeyboardLayout.h
//  AquaSKKCore
//
//  Created by mzp on 8/6/24.
//

#import <Carbon/Carbon.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// TISInputSourceRef のラッパー
NS_SWIFT_NAME(KeyboardLayout)
@interface AISKeyboardLayout : NSObject

@property(nonatomic, readonly) TISInputSourceRef inputSourceRef;

@property(nonatomic, readonly) NSString *inputSourceID;
@property(nonatomic, readonly) NSString *localizedName;
@property(nonatomic, readonly) NSImage *icon;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTISInputSourceRef:(TISInputSourceRef)inputSourceRef NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
