//
//  AIIClipboard.m
//  AquaSKKInput
//
//  Created by mzp on 8/25/24.
//

#import "AIIClipboard.h"

#import <Foundation/Foundation.h>

namespace AquaSKKInput {
    Clipboard::Clipboard(id<AIIClipboard> clipboard)
        : clipboard_(clipboard) {}

    const std::string Clipboard::PasteString() {
        NSString *str = [clipboard_ pasteString];
        return [str UTF8String];
    }
} // namespace AquaSKKInput
