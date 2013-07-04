#import "LSASIHTTPRequestHook.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+Stub.h"
#import <objc/runtime.h>

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
    Method originalMethod = class_getInstanceMethod([ASIHTTPRequest class], original);
    Method stubMethod = class_getInstanceMethod([ASIHTTPRequest class], stub);
    if (!originalMethod || !stubMethod) {
        [self fail];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (void)fail {
    [NSException raise:NSInternalInconsistencyException format:@"Couldn't load ASIHTTPRequest hook."];
}

@end
