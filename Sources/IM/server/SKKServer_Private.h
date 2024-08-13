#import <AquaSKKIM/SKKServer.h>

@interface SKKServer (Private)

/// Start SKKServer without IMK connection. Testing only.
- (void)_start;

/// Path for managed resource.
- (NSString *)pathForResource:(NSString *)path;

@end
