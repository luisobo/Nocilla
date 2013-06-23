#import "ASIHTTPRequestStub.h"
#import "LSNocilla.h"
#import "LSStubResponse.h"
#import "LSASIHTTPRequestAdapter.h"

@interface ASIHTTPRequestStub ()
@property (nonatomic, strong) LSStubResponse *stubResponse;
@end

@implementation ASIHTTPRequestStub

- (int)responseStatusCode {
    return self.stubResponse.statusCode;
}

- (NSData *)responseData {
    return self.stubResponse.body;
}

- (NSDictionary *)responseHeaders {
    return self.stubResponse.headers;
}

- (void)main {
    self.stubResponse = [[LSNocilla sharedInstance] responseForRequest:[[LSASIHTTPRequestAdapter alloc] initWithASIHTTPRequest:self]];

    [self requestFinished];
}

@end
