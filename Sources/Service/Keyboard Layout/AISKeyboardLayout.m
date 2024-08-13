//
//  AISKeyboardLayout.m
//  AquaSKKCore
//
//  Created by mzp on 8/6/24.
//

#import "AISKeyboardLayout.h"
#import <Cocoa/Cocoa.h>

@implementation AISKeyboardLayout

- (instancetype)initWithTISInputSourceRef:(TISInputSourceRef)inputSourceRef {
    self = [super init];
    if (self) {
        _inputSourceRef = inputSourceRef;
    }
    return self;
}

- (void)dealloc {
    CFRelease(self.inputSourceRef);
}

- (NSString *)inputSourceID {
    return (__bridge NSString *)TISGetInputSourceProperty(self.inputSourceRef, kTISPropertyInputSourceID);
}

- (NSString *)localizedName {
    return (__bridge NSString *)TISGetInputSourceProperty(self.inputSourceRef, kTISPropertyLocalizedName);
}

- (NSImage *)icon {

    IconRef iconref = (IconRef)TISGetInputSourceProperty(self.inputSourceRef, kTISPropertyIconRef);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSImage *image = [[NSImage alloc] initWithIconRef:iconref];
#pragma clang diagnostic pop
    return image;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<AISKeyboardLayout: %p; id=%@>", self, self.inputSourceID];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else if ([other isKindOfClass:AISKeyboardLayout.class]) {
        AISKeyboardLayout *otherLayout = (AISKeyboardLayout *)other;
        return [self.inputSourceID isEqualToString:otherLayout.inputSourceID];
    } else {
        return NO;
    }
}

- (NSUInteger)hash {
    return self.inputSourceID.hash;
}

@end
