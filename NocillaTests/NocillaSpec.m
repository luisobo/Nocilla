
#import "Kiwi.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Nocilla.h"

SPEC_BEGIN(NocillaSpec)

// networksetup -setwebproxy "Wi-Fi" 127.0.0.1 12345
// networksetup -setwebproxystate "Wi-Fi" off

it(@"should stub the request", ^{
    [[LSNocilla sharedInstace] start];
    
    stubRequest(@"POST", @"http://localhost:12345/say-hello").
    withHeader(@"Content-Type", @"text/plain; charset=utf8").
    withHeader(@"Cacatuha!!!", @"sisisi").
    withBody(@"caca").
    andReturn(403).
    withHeader(@"Content-Type", @"text/plain").
    withBody(@"Hello World!");
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://localhost:12345/say-hello"]];
    [request addRequestHeader:@"Content-Type" value:@"text/plain; charset=utf8"];
    [request addRequestHeader:@"Cacatuha!!!" value:@"sisisi"];
    [request appendPostData:[[@"caca" dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    [request startSynchronous];
    
    [request.error shouldBeNil];
    [[request.responseString should] equal:@"Hello World!"];
    [[theValue(request.responseStatusCode) should] equal:theValue(403)];
    [[[request.responseHeaders objectForKey:@"Content-Type"] should] equal: @"text/plain"];
});

SPEC_END