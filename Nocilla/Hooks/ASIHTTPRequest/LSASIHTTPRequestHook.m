#import "LSASIHTTPRequestHook.h"
#import "JRSwizzle.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+Stub.h"

@implementation LSASIHTTPRequestHook

- (void)load {
    [self swizzleASIHTTPRequestInit];
}

- (void)unload {
    [self swizzleASIHTTPRequestInit];
}

#pragma mark - Internal Methods

- (void)swizzleASIHTTPRequestInit {
    NSError *error = nil;
    BOOL success = [ASIHTTPRequest jr_swizzleMethod:@selector(initWithURL:)
                                         withMethod:@selector(stub_initWithURL:)
                                              error:&error];
    if (!success) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load ASIHTTPRequest hook"];
    }
}

@end
