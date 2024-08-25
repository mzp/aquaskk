//
//  SandboxShims.m
//  AquaSKKService
//
//  Created by mzp on 8/24/24.
//

#import "SandboxShims.h"
#include <unistd.h>
#include <pwd.h>

NSString *AISHomeDirectory(void) {
    // https://blog.rinsuki.net/articles/get-actual-home-path-from-sandbox/
    uid_t uid = getuid();
    struct passwd* pw = getpwuid(uid);
    const char* path= pw->pw_dir;
    return [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
}
