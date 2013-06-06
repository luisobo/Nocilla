#import "ASIHTTPRequestStub.h"
#import "LSNocilla.h"
#import "LSStubResponse.h"
#import "LSASIHTTPRequestAdapter.h"

@interface ASIHTTPRequestStub (Private)
- (void)reportFailure;
- (void)reportFinished;
@end

@interface ASIHTTPRequestStub ()
@property (nonatomic, strong) LSStubResponse *stubResponse;
@end

@implementation ASIHTTPRequestStub

- (int)responseStatusCode {
    return self.stubResponse.statusCode;
}

- (void)main {
    self.stubResponse = [[LSNocilla sharedInstance] responseForRequest:[[LSASIHTTPRequestAdapter alloc] initWithASIHTTPRequest:self]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportFinished];
    });
}

@end
