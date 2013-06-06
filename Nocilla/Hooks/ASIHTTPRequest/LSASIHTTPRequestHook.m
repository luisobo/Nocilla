#import "LSASIHTTPRequestHook.h"
#import "JRSwizzle.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+Stub.h"

@implementation LSASIHTTPRequestHook

- (void)load {
    NSError *error = nil;
    BOOL success = [ASIHTTPRequest jr_swizzleMethod:@selector(initWithURL:)
                                         withMethod:@selector(stub_initWithURL:)
                                              error:&error];
    if (!success) {
        [NSException raise:@"WAAAH" format:@"BOOO"];
    }
}

- (void)unload {
    NSError *error = nil;
    BOOL success = [ASIHTTPRequest jr_swizzleMethod:@selector(initWithURL:)
                                         withMethod:@selector(stub_initWithURL:)
                                              error:&error];
    if (!success) {
        [NSException raise:@"WAAAH" format:@"BOOO"];
    }
}

@end
