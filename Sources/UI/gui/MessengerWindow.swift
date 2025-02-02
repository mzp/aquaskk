//
//  MessengerWindow.swift
//  AquaSKKUI
//
//  Created by mzp on 1/24/25.
//

import AppKit

@objc(MessengerWindow)
public class MessengerWindow: NSObject {
    public static let sharedInstance = MessengerWindow()

    @objc(sharedWindow)
    public static func shared() -> MessengerWindow {
        return sharedInstance
    }

    private let view: MessengerView
    private let window: NSWindow
    override public init() {
        view = MessengerView()
        window = .init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: true)
        window.backgroundColor = .clear
        window.isOpaque = false
        window.ignoresMouseEvents = true
        window.contentView = view
        super.init()
    }

    @objc(showMessage:at:level:)
    public func showMessage(_ message: String, at topLeft: CGPoint, level: NSWindow.Level) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        view.setMessage(message)
        window.setFrame(view.frame, display: false)
        window.setFrameTopLeftPoint(topLeft)
        window.level = level
        window.alphaValue = 1.0
        window.orderFront(nil)

        Task { [weak self] in
            try await Task.sleep(for: .milliseconds(1500))
            self?.hide()
        }
    }

    @objc(hide)
    public func hide() {
        let animation = NSViewAnimation(viewAnimations: [
            [.target: window],
            [.effect: NSViewAnimation.EffectName.fadeOut],
        ])
        animation.duration = 0.5
        animation.start()
    }
}

// #import <AquaSKKUI/MessengerView.h>
// #import <AquaSKKUI/MessengerWindow.h>
//
// @implementation MessengerWindow
//
// + (MessengerWindow *)sharedWindow {
//    static MessengerWindow *obj = [[MessengerWindow alloc] init];
//
//    return obj;
// }
//
// - (id)init {
//    self = [super init];
//    if(self) {
//        view_ = [[MessengerView alloc] init];
// #pragma clang diagnostic push
// #pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        window_ = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 0, 0)
//                                              styleMask:NSBorderlessWindowMask
//                                                backing:NSBackingStoreBuffered
//                                                  defer:YES];
// #pragma clang diagnostic pop
//        [window_ setBackgroundColor:[NSColor clearColor]];
//        [window_ setOpaque:NO];
//        [window_ setIgnoresMouseEvents:YES];
//        [window_ setContentView:view_];
//    }
//    return self;
// }
//
// - (void)dealloc {
//    [window_ release];
//    [view_ release];
//
//    [super dealloc];
// }
//
// - (void)showMessage:(NSString *)msg at:(NSPoint)topleft level:(int)level {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//
//    [view_ setMessage:msg];
//
//    [window_ setFrame:[view_ frame] display:NO];
//    [window_ setFrameTopLeftPoint:topleft];
//    [window_ setLevel:level];
//    [window_ setAlphaValue:1.0];
//    [window_ orderFront:nil];
//
//    [self performSelector:@selector(hideNotify:) withObject:self afterDelay:1.5];
// }
//
// - (void)hide {
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:2];
//
//    [dictionary setObject:window_ forKey:NSViewAnimationTargetKey];
//    [dictionary setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
//
//    NSViewAnimation *animation =
//        [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dictionary, nil]];
//
//    [animation setDuration:0.5];
//    [animation startAnimation];
//    [animation release];
// }
//
// - (void)hideNotify:(id)sender {
//    [self hide];
// }
//
// @end
//
