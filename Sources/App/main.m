//
//  main.c
//  AquaSKK
//
//  Created by mzp on 8/15/24.
//

#import <AppKit/AppKit.h>
#import <os/log.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@end

int main(int argc, const char **argv) {
    os_log_t appLog = os_log_create("com.aquaskk.inputmethods", "app");
    os_log(appLog,
           "🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻"
           "AquaSKK: An input method without morphological analysis."
           "Complied timestamp: %s"
           "🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻",
           __TIMESTAMP__);

    NSApplication *application = [NSApplication sharedApplication];
    AppDelegate *delegate = [[AppDelegate alloc] init];
    os_log(appLog, "application=%@", application);
    os_log(appLog, "delegate=%@", delegate);
    [application setDelegate:delegate];
    [application run];
    return 0;
}
