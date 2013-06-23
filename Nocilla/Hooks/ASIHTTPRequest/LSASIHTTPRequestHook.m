#import "LSASIHTTPRequestHook.h"
#import "JRSwizzle.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+Stub.h"

@implementation LSASIHTTPRequestHook

- (void)load {
    [self swizzleASIHTTPRequest];
}

- (void)unload {
    [self swizzleASIHTTPRequest];
}

#pragma mark - Internal Methods

- (void)swizzleASIHTTPRequest {
    [self swizzleASIHTTPSelector:@selector(responseStatusCode) withSelector:@selector(stub_responseStatusCode)];
    [self swizzleASIHTTPSelector:@selector(responseData) withSelector:@selector(stub_responseData)];
    [self swizzleASIHTTPSelector:@selector(responseHeaders) withSelector:@selector(stub_responseHeaders)];
    [self swizzleASIHTTPSelector:@selector(startRequest) withSelector:@selector(stub_startRequest)];
}

- (void)swizzleASIHTTPSelector:(SEL)original withSelector:(SEL)stub {
    NSError *error = nil;
    
    BOOL success = [ASIHTTPRequest jr_swizzleMethod:original
                                         withMethod:stub
                                              error:&error];
    if (!success) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load ASIHTTPRequest hook"];
    }
}

@end
