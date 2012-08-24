#import "Kiwi.h"
#import "AFNetworking.h"
#import "Nocilla.h"

SPEC_BEGIN(NocillaSpec)

// networksetup -setwebproxy "Wi-Fi" 127.0.0.1 12345
// networksetup -setwebproxystate "Wi-Fi" off
beforeAll(^{
    [[LSNocilla sharedInstance] start];
});
afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});

context(@"AFNetworking", ^{
    it(@"should stub the request", ^{
        stubRequest(@"POST", @"https://getshopkeep.com/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"Cacatuha!!!", @"sisisi").
        withBody(@"caca").
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"hola");
        
        NSURL *url = [NSURL URLWithString:@"https://getshopkeep.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"Cacatuha!!!"];
        [request setHTTPBody:[@"caca" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation start];
        
        [operation waitUntilFinished];
        
        [operation.error shouldBeNil];
        [[operation.responseString should] equal:@"hola"];
        [[theValue(operation.response.statusCode) should] equal:theValue(200)];
        [[[operation.response.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];
    });
});
SPEC_END