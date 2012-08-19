#import "Kiwi.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Nocilla.h"

SPEC_BEGIN(NocillaSpec)

// networksetup -setwebproxy "Wi-Fi" 127.0.0.1 12345
// networksetup -setwebproxystate "Wi-Fi" off

it(@"should stub the request", ^{
    [[LSNocilla sharedInstace] start];
    
//    stubRequest(@"POST", @"http://localhost:12345/say-hello").andReturn(403).withBody(@"Hello World!").withHeader(@"Content-Type", @"text/plain");
    stubRequest(@"POST", @"http://localhost:12345/say-hello").andReturn(201);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://localhost:12345/say-hello"]];
    [request startSynchronous];
    
    NSLog(@"%@", request.error);
    NSLog(@"%@", request.responseString);
    NSLog(@"%d", request.responseStatusCode);
    NSLog(@"%@", request.responseHeaders);
});

SPEC_END