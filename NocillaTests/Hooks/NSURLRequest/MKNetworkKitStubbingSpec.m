#import "Kiwi.h"
#import "MKNetworkKit.h"
#import "Nocilla.h"

SPEC_BEGIN(MKNetworkKitStubbingSpec)

// networksetup -setwebproxy "Wi-Fi" 127.0.0.1 12345
// networksetup -setwebproxystate "Wi-Fi" off
beforeAll(^{
    [[LSNocilla sharedInstance] start];
});
afterAll(^{
    [[LSNocilla sharedInstance] stop];
});
afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});

context(@"MKNetworkKit", ^{
    it(@"should stub an asynchronous request", ^{
        stubRequest(@"POST", @"http://getshopkeep.com/say-hello").
        withHeaders(@{ @"Cacatuha!!!": @"sisisi", @"Content-Type": @"application/x-www-form-urlencoded; charset=utf-8,text/plain" }).
        withBody(@"{\"text\":\"hola\"}").
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"{\"text\":\"adios\"}");
        
        MKNetworkOperation *operation = [[MKNetworkOperation alloc]
                                         initWithURLString:@"http://getshopkeep.com/say-hello"
                                         params:[@{ @"text" : @"hola" } mutableCopy]
                                         httpMethod:@"POST"];
        [operation addHeaders: @{
         @"Content-Type" : @"text/plain",
         @"Cacatuha!!!" : @"sisisi" }];
        
        [operation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
        [operation start];

        [[expectFutureValue(operation.responseString) shouldEventually] equal:@"{\"text\":\"adios\"}"];
        [operation.error shouldBeNil];
        [[theValue(operation.readonlyResponse.statusCode) should] equal:theValue(200)];
        [[[operation.readonlyResponse.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];
    });
});
SPEC_END