#import "Kiwi.h"
#import "LSNSURLHook.h"
#import "LSHTTPStubURLProtocol.h"

SPEC_BEGIN(LSNSURLHookSpec)
describe(@"#load", ^{
    it(@"should register LSHTTPStubURLProtocol as a NSURLProtocol", ^{
        LSNSURLHook *hook = [[LSNSURLHook alloc] init];
        
        [[NSURLProtocol class] stub:@selector(registerClass:)];
        [[[NSURLProtocol should] receive] registerClass:[LSHTTPStubURLProtocol class]];
        
        [hook load];
    });
});

describe(@"#unload", ^{
    it(@"should unregister LSHTTPStubURLProtocol as a NSURLProtocol", ^{
        LSNSURLHook *hook = [[LSNSURLHook alloc] init];
        
        [[NSURLProtocol class] stub:@selector(unregisterClass:)];
        [[[NSURLProtocol should] receive] unregisterClass:[LSHTTPStubURLProtocol class]];
        
        [hook unload];
    });
});
SPEC_END