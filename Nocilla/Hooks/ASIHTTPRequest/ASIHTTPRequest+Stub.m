#import "ASIHTTPRequest+Stub.h"
#import "LSStubResponse.h"
#import "LSNocilla.h"
#import "LSASIHTTPRequestAdapter.h"
#import <objc/runtime.h>

@interface ASIHTTPRequest (Stub_Private)
@property (nonatomic, strong) LSStubResponse *stubResponse;
@end

static void const * ASIHTTPRequestStubResponseKey = &ASIHTTPRequestStubResponseKey;

@implementation ASIHTTPRequest (Stub)

- (void)setStubResponse:(LSStubResponse *)stubResponse {
    objc_setAssociatedObject(self, ASIHTTPRequestStubResponseKey, stubResponse, OBJC_ASSOCIATION_RETAIN);
}

- (LSStubResponse *)stubResponse {
    return objc_getAssociatedObject(self, ASIHTTPRequestStubResponseKey);
}

- (int)stub_responseStatusCode {
    return self.stubResponse.statusCode;
}

- (NSData *)stub_responseData {
    return self.stubResponse.body;
}

- (NSDictionary *)stub_responseHeaders {
    return self.stubResponse.headers;
}

- (void)stub_startRequest {
    self.stubResponse = [[LSNocilla sharedInstance] responseForRequest:[[LSASIHTTPRequestAdapter alloc] initWithASIHTTPRequest:self]];

    if (self.stubResponse.shouldFail) {
        [self failWithError:self.stubResponse.error];
    } else {
        [self requestFinished];
    }
}

@end