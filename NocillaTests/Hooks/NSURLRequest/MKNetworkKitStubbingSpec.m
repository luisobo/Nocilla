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
    it(@"should be able to dowload google.com", ^{
//        [[LSNocilla sharedInstance] stop];
//        MKNetworkOperation *operation = [[MKNetworkOperation alloc]
//                                         initWithURLString:@"http://www.google.com"
//                                         params:[@{} mutableCopy]
//                                         httpMethod:@"GET"];
//
//        [operation start];
//        
//        do {
//            [NSThread sleepForTimeInterval:0.3];
//        } while(!operation.readonlyResponse.statusCode);
//        
//        NSLog(@"%@", operation.responseString);
//        NSLog(@"%d", operation.readonlyResponse.statusCode);
//        [[LSNocilla sharedInstance] start];
    });
//    it(@"should stub the request", ^{
//        stubRequest(@"POST", @"http://getshopkeep.com/say-hello").
//        withHeader(@"Content-Type", @"text/plain").
//        withHeader(@"Cacatuha!!!", @"sisisi").
//        withBody(@"caca").
//        andReturn(200).
//        withHeader(@"Content-Type", @"text/plain").
//        withBody(@"{\"text\":\"hola\"}");
//        
//        MKNetworkOperation *operation = [[MKNetworkOperation alloc]
//                                         initWithURLString:@"http://getshopkeep.com/say-hello"
//                                         params:[@{ @"text" : @"hola" } mutableCopy]
//                                         httpMethod:@"POST"];
//        [operation addHeaders: @{
//         @"Content-Type" : @"text/plain",
//         @"Cacatuha!!!" : @"sisisi" }];
//        
//        [operation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
//        [operation start];
//
//        [operation waitUntilFinished];
//        [operation.error shouldBeNil];
//        [[operation.responseString should] equal:@"hola"];
//        [[theValue(operation.readonlyResponse.statusCode) should] equal:theValue(200)];
//        [[[operation.readonlyResponse.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];
//    });
});
SPEC_END