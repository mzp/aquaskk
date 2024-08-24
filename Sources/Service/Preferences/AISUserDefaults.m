//
//  AISUserDefaults.m
//  AquaSKKService
//
//  Created by mzp on 8/24/24.
//

#import "AISUserDefaults.h"
#import <os/log.h>

static os_log_t serviceLog(void) {
    static os_log_t _serviceLog;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceLog = os_log_create("com.aquaskk.inputmethod", "Service");
    });
    return _serviceLog;
}


@interface AISUserDefaults()
@property(nonatomic, strong) id<AISServerConfiguration> serverConfiguration;
@end

@implementation AISUserDefaults

- (instancetype)initWithServerConfiguration:(id<AISServerConfiguration>)serverConfiguration
{
    self = [super init];
    if(self) {
        self.serverConfiguration = serverConfiguration;
    }
    return self;
}

- (void)prepareUserDefaults {
    NSString* factoryDefaults = self.serverConfiguration.factoryUserDefaultsPath;
    NSString* userDefaults = self.serverConfiguration.userDefaultsPath;

    os_log(serviceLog(), "%s: factory=%{public}@ to %{public}@", __PRETTY_FUNCTION__, factoryDefaults, userDefaults);
    NSMutableDictionary* defaults = [NSMutableDictionary dictionaryWithContentsOfFile:factoryDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:userDefaults]];
    [defaults writeToFile:userDefaults atomically:YES];

    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSUserDefaults *)standardDefaults
{
    return NSUserDefaults.standardUserDefaults;
}
@end
