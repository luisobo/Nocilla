#import "ASIHTTPRequest+Stub.h"
#import "ASIHTTPRequestStub.h"

@implementation ASIHTTPRequest (Stub)

- (id)stub_initWithURL:(NSURL *)newURL {
    ASIHTTPRequestStub *result = [[ASIHTTPRequestStub alloc] stub_initWithURL:newURL];
    return result;
}

@end