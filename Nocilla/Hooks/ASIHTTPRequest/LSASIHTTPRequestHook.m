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
    method_exchangeImplementations(
                                   class_getInstanceMethod([ASIHTTPRequest class], original),
                                   class_getInstanceMethod([ASIHTTPRequest class], stub));

}

@end
