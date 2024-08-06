//
//  AISSystemResourceConfiguration.m
//  AquaSKKCore
//
//  Created by mzp on 8/6/24.
//

#import "AISSystemResourceConfiguration.h"
#import <AquaSKKService/SKKConstVars.h>

@implementation AISSystemResourceConfiguration

- (NSString *)pathForSystemResource:(NSString *)path {
    return [NSString stringWithFormat:@"%@/%@", SKKFilePaths::SystemResourceFolder, path];
}

- (NSString *)pathForUserResource:(NSString *)path {
    return [NSString stringWithFormat:@"%@/%@", SKKFilePaths::ApplicationSupportFolder, path];
}

- (NSString *)pathForResource:(NSString *)path {
    NSString* tmp = [self pathForUserResource:path];

    if([self fileExistsAtPath:tmp] == YES) {
        return tmp;
    } else {
        return [self pathForSystemResource:path];
    }
}

- (BOOL)fileExistsAtPath:(NSString *)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

@end
