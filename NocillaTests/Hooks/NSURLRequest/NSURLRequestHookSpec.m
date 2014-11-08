#import "Kiwi.h"
#import "LSNSURLHook.h"
#import "LSHTTPStubURLProtocol.h"

SPEC_BEGIN(LSNSURLHookSpec)
describe(@"#load", ^{
    it(@"should register LSHTTPStubURLProtocol as a NSURLProtocol", ^{
        LSNSURLHook *hook = [[LSNSURLHook alloc] init];
        [[NSURLProtocol should] receive:@selector(registerClass:) withArguments:[LSHTTPStubURLProtocol class]];

        [hook load];
    });
});

describe(@"#unload", ^{
    it(@"should unregister LSHTTPStubURLProtocol as a NSURLProtocol", ^{
        LSNSURLHook *hook = [[LSNSURLHook alloc] init];

        [[NSURLProtocol should] receive:@selector(unregisterClass:) withArguments:[LSHTTPStubURLProtocol class]];
        
        [hook unload];
    });
});
SPEC_END