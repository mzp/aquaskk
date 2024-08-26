//
//  AIIClipboard.h
//  AquaSKKInput
//
//  Created by mzp on 8/25/24.
//

#import <Foundation/Foundation.h>

#import <AquaSKKCore/SKKClipboard.h>

@protocol AIIClipboard <NSObject>
@property(nonatomic, readonly) NSString *pasteString;
@end

@protocol AIIClipboardProvider
@optional
- (id<AIIClipboard>)newClipboard;
@end

namespace AquaSKKInput {
    class Clipboard : public SKKClipboard {
        id<AIIClipboard> clipboard_;

    public:
        Clipboard(id<AIIClipboard> clipboard);
        virtual const std::string PasteString();
    };
} // namespace AquaSKKInput
