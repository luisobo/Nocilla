#import "Kiwi.h"
#import "MKNetworkKit.h"
#import "Nocilla.h"
#import "HTTPServer.h"
#import "LSTestingConnection.h"

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
    
    it(@"should have the same result as a real HTTP request", ^{
        NSURL *url = [NSURL URLWithString:@"http://localhost:12345/say-hello"];
        
        [[LSNocilla sharedInstance] stop];
        
        HTTPServer *server = [[HTTPServer alloc] init];
        [server setPort:12345];
        NSError *error;
        [server setConnectionClass:[LSTestingConnection class]];
        [server start:&error];
        [error shouldBeNil];
        
        
        MKNetworkOperation *realOperation = [[MKNetworkOperation alloc]
                                         initWithURLString:url.absoluteString
                                         params:[@{ @"this is" : @"the body" } mutableCopy]
                                         httpMethod:@"POST"];
        [realOperation addHeaders: @{
         @"Content-Type" : @"application/json",
         @"X-MY-AWESOME-HEADER" : @"sisisi" }];
        
        [realOperation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
        [realOperation start];
        
        
        [[expectFutureValue(theValue(realOperation.readonlyResponse.statusCode)) shouldEventually] equal:theValue(200)];
        [realOperation.error shouldBeNil];
        [[realOperation.responseString should] equal:@"hola"];
        
        
        NSHTTPURLResponse *realResponse = realOperation.readonlyResponse;
        NSString *realBody = realOperation.responseString;
        
        [server stop];
        
        [[LSNocilla sharedInstance] start];
        
        stubRequest(@"POST", @"http://localhost:12345/say-hello").
        withHeaders(@{ @"Content-Type": @"application/json; charset=utf-8", @"X-MY-AWESOME-HEADER": @"sisisi" }).
        withBody(@"{\"this is\":\"the body\"}").
        andReturn(200).
        withHeaders([realResponse allHeaderFields]).
        withBody(@"hola");
        
        
        
        MKNetworkOperation *stubbedOperation = [[MKNetworkOperation alloc]
                                             initWithURLString:url.absoluteString
                                             params:[@{ @"this is" : @"the body" } mutableCopy]
                                             httpMethod:@"POST"];
        [stubbedOperation addHeaders: @{
         @"Content-Type" : @"application/json",
         @"X-MY-AWESOME-HEADER" : @"sisisi" }];
        
        [stubbedOperation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
        [stubbedOperation start];
        
        [[expectFutureValue(theValue(stubbedOperation.readonlyResponse.statusCode)) shouldEventually] equal:theValue(200)];
        
        [[stubbedOperation.responseString should] equal:@"hola"];
        [stubbedOperation.error shouldBeNil];
        
        
        
        NSHTTPURLResponse *stubbedResponse = stubbedOperation.readonlyResponse;
        NSString *stubbedBody = stubbedOperation.responseString;
        
        
        NSDictionary *realHeaders = [realResponse allHeaderFields];
        NSDictionary *stubbedHeaders = [stubbedResponse allHeaderFields];
        [[theValue(realResponse.statusCode) should] equal:theValue(stubbedResponse.statusCode)];
        [[realHeaders should] equal:stubbedHeaders];
        [[realBody should] equal:stubbedBody];
    });

});
SPEC_END