#import "Kiwi.h"
#import "MKNetworkKit.h"
#import "Nocilla.h"

SPEC_BEGIN(MKNetworkKitStubbingSpec)

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
        stubRequest(@"POST", @"http://example.com/say-hello").
        withHeaders(@{ @"X-MY-AWESOME-HEADER": @"sisisi", @"Content-Type": @"application/json; charset=utf-8" }).
        withBody(@"{\"text\":\"hola\"}").
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"{\"text\":\"adios\"}");
        
        MKNetworkOperation *operation = [[MKNetworkOperation alloc]
                                         initWithURLString:@"http://example.com/say-hello"
                                         params:[@{ @"text" : @"hola" } mutableCopy]
                                         httpMethod:@"POST"];
        [operation addHeaders: @{
         @"Content-Type" : @"text/plain",
         @"X-MY-AWESOME-HEADER" : @"sisisi" }];
        
        [operation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
        [operation start];
        
        
        

        [[expectFutureValue(operation.responseString) shouldEventually] equal:@"{\"text\":\"adios\"}"];
        
        [operation.error shouldBeNil];
        [[theValue(operation.readonlyResponse.statusCode) should] equal:theValue(200)];
        [[[operation.readonlyResponse.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];
    });
});
SPEC_END