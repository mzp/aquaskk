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

@interface AISUserDefaults ()
@property(nonatomic, strong) id<AISServerConfiguration> serverConfiguration;
@property(nonatomic, strong) NSUserDefaults *standardDefaults;
@end

@implementation AISUserDefaults

- (instancetype)initWithServerConfiguration:(id<AISServerConfiguration>)serverConfiguration {
    self = [super init];
    if(self) {
        self.serverConfiguration = serverConfiguration;
        self.standardDefaults = NSUserDefaults.standardUserDefaults;
    }
    return self;
}

- (void)prepareUserDefaults {
    NSString *factoryDefaults = self.serverConfiguration.factoryUserDefaultsPath;
    NSString *userDefaults = self.serverConfiguration.userDefaultsPath;

    os_log(serviceLog(), "%s: factory=%{public}@ to %{public}@", __PRETTY_FUNCTION__, factoryDefaults, userDefaults);
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:factoryDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:userDefaults]];
    [defaults writeToFile:userDefaults atomically:YES];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveChanges {
    NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
    os_log(serviceLog(), "%s:bundleID=%{public}@", __PRETTY_FUNCTION__, bundleIdentifier);
    NSDictionary *preference = [self.standardDefaults persistentDomainForName:bundleIdentifier];
    os_log_info(serviceLog(), "%s:%{private}@", __PRETTY_FUNCTION__, preference);
    [preference writeToFile:self.serverConfiguration.userDefaultsPath atomically:YES];
}

- (void)reloadUserDefaults {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *path = self.serverConfiguration.userDefaultsPath;
    os_log(
        serviceLog(), "%s UserDefaults(path=%{public}@; bundleID=%{public}@)", __PRETTY_FUNCTION__, path,
        bundleIdentifier);

    NSUserDefaults *defaults = self.standardDefaults;
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:path];
    os_log(serviceLog(), "%s content=%{private}@", __PRETTY_FUNCTION__, prefs);

    // force update userdeafults
    [defaults setPersistentDomain:prefs forName:bundleIdentifier];
}

@end
