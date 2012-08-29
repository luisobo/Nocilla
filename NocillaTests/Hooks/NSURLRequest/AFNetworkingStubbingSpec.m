#import "Kiwi.h"
#import "AFNetworking.h"
#import "Nocilla.h"
#import "HTTPServer.h"
#import "HTTPConnection.h"
#import "HTTPDataResponse.h"

@interface LSTestingConnection : HTTPConnection

@end
@implementation LSTestingConnection

-(BOOL) supportsMethod:(NSString *)method atPath:(NSString *)path {
    return YES;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSObject<HTTPResponse> *response = [[HTTPDataResponse alloc] initWithData:[@"hola" dataUsingEncoding:NSUTF8StringEncoding]];

    return response;
}


@end


SPEC_BEGIN(AFNetworkingStubbingSpec)

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
    

    it(@"should have the same result as a real HTTP request", ^{
        NSURL *url = [NSURL URLWithString:@"http://localhost:12345/say-hello"];        
        
        [[LSNocilla sharedInstance] stop];
        
        HTTPServer *server = [[HTTPServer alloc] init];
        [server setPort:12345];
        NSError *error;
        [server setConnectionClass:[LSTestingConnection class]];
        [server start:&error];
        [error shouldBeNil];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"Cacatuha!!!"];
        [request setHTTPBody:[@"caca" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *realOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [realOperation start];

        [realOperation waitUntilFinished];

        [realOperation.error shouldBeNil];
        [[realOperation.responseString should] equal:@"hola"];
        [[theValue(realOperation.response.statusCode) should] equal:theValue(200)];
        
        NSHTTPURLResponse *realResponse = realOperation.response;
        NSString *realBody = realOperation.responseString;
        
        [server stop];
        
        [[LSNocilla sharedInstance] start];
        
        stubRequest(@"POST", @"http://localhost:12345/say-hello").
        withHeaders(@{@"Content-Type" : @"text/plain", @"Cacatuha!!!" : @"sisisi"}).
        withBody(@"caca").
        andReturn(200).
        withHeaders([realResponse allHeaderFields]).
        withBody(@"hola");
        
        
        
        NSMutableURLRequest *stubbedRequest = [NSMutableURLRequest requestWithURL:url];
        [stubbedRequest setHTTPMethod:@"POST"];
        [stubbedRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [stubbedRequest setValue:@"sisisi" forHTTPHeaderField:@"Cacatuha!!!"];
        [stubbedRequest setHTTPBody:[@"caca" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *stubbedOperation = [[AFHTTPRequestOperation alloc] initWithRequest:stubbedRequest];
        [stubbedOperation start];
        
        [stubbedOperation waitUntilFinished];
        
        [stubbedOperation.error shouldBeNil];
        [[stubbedOperation.responseString should] equal:@"hola"];
        [[theValue(stubbedOperation.response.statusCode) should] equal:theValue(200)];
        
        NSHTTPURLResponse *stubbedResponse = stubbedOperation.response;
        NSString *stubbedBody = stubbedOperation.responseString;

        
        NSDictionary *realHeaders = [realResponse allHeaderFields];
        NSDictionary *stubbedHeaders = [stubbedResponse allHeaderFields];
        [[theValue(realResponse.statusCode) should] equal:theValue(stubbedResponse.statusCode)];
        [[realHeaders should] equal:stubbedHeaders];
        [[realBody should] equal:stubbedBody];
    });
});
SPEC_END