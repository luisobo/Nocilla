#import "LSNSURLHook.h"
#import "LSHTTPStubURLProtocol.h"

@implementation LSNSURLHook

- (void)load {
    [NSURLProtocol registerClass:self.urlProtocolClass];
}

- (void)unload {
    [NSURLProtocol unregisterClass:self.urlProtocolClass];
}

@end
