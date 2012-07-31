#import "Kiwi.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Nocilla.h"

SPEC_BEGIN(NocillaSpec)

// networksetup -setwebproxy "Wi-Fi" 127.0.0.1 12345
// networksetup -setwebproxystate "Wi-Fi" off

it(@"should stub the request", ^{
    
    [[LSNocilla sharedInstace] start];
    
    stubRequest(@"POST", @"http://localhost:12345").andReturn(200).withBody(@"Hello World!").withHeader(@"Content-Type", @"text/plain");
    
    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://api.events.theshopkeep.com/healthcheck"]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://localhost:12345"]];
    
    [request startSynchronous];
    
    NSLog(@"%@", request.responseString);
});

SPEC_END