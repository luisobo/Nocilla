#import "Kiwi.h"
#import "AFNetworking.h"
#import "Nocilla.h"
#import "HTTPServer.h"
#import "LSTestingConnection.h"

SPEC_BEGIN(AFNetworkingStubbingSpec)

beforeEach(^{
    [[LSNocilla sharedInstance] start];
});
afterEach(^{
    [[LSNocilla sharedInstance] stop];
    [[LSNocilla sharedInstance] clearStubs];
});

context(@"AFNetworking", ^{
    it(@"should stub the request", ^{
        stubRequest(@"POST", @"https://example.com/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"X-MY-AWESOME-HEADER", @"sisisi").
        withBody(@"Adios!").
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"hola");
        
        NSURL *url = [NSURL URLWithString:@"https://example.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation start];
        
        [operation waitUntilFinished];
        
        [operation.error shouldBeNil];
        [[operation.responseString should] equal:@"hola"];
        [[theValue(operation.response.statusCode) should] equal:theValue(200)];
        [[[operation.response.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];
    });
    
    it(@"should stub the request with a raw reponse", ^{
        stubRequest(@"POST", @"https://example.com/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"X-MY-AWESOME-HEADER", @"sisisi").
        withBody(@"Adios!").
        andReturnRawResponse([@"HTTP/1.1 200 OK\nContent-Type: text/plain\n\nhola" dataUsingEncoding:NSUTF8StringEncoding]);
        
        NSURL *url = [NSURL URLWithString:@"https://example.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
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
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
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
        withHeaders(@{@"Content-Type" : @"text/plain", @"X-MY-AWESOME-HEADER" : @"sisisi"}).
        withBody(@"Adios!").
        andReturn(200).
        withHeaders([realResponse allHeaderFields]).
        withBody(@"hola");
        
        
        
        NSMutableURLRequest *stubbedRequest = [NSMutableURLRequest requestWithURL:url];
        [stubbedRequest setHTTPMethod:@"POST"];
        [stubbedRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [stubbedRequest setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [stubbedRequest setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
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
    
    it(@"should stub an asynchronous request", ^{
        stubRequest(@"POST", @"https://example.com/say-hello").
        withHeaders(@{ @"X-MY-AWESOME-HEADER": @"sisisi", @"Content-Type": @"text/plain" }).
        withBody(@"Adios!").
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"hola");
        
        NSURL *url = [NSURL URLWithString:@"https://example.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation start];
        
        [[expectFutureValue(theValue(operation.response.statusCode)) shouldEventually] equal:theValue(200)];
        [[operation.responseString should] equal:@"hola"];
        
        [[[operation.response.allHeaderFields objectForKey:@"Content-Type"] shouldEventually] equal:@"text/plain"];
        [operation.error shouldBeNil];
    });

    it(@"stubs a request with an error", ^{
        NSError *error = [NSError errorWithDomain:@"com.luisobo.nocilla" code:123 userInfo:@{NSLocalizedDescriptionKey:@"Failing, failing... 1, 2, 3..."}];

        stubRequest(@"POST", @"https://example.com/say-hello").
        withHeaders(@{ @"X-MY-AWESOME-HEADER": @"sisisi", @"Content-Type": @"text/plain" }).
        withBody(@"Adios!").
        andFailWithError(error);

        NSURL *url = [NSURL URLWithString:@"https://example.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];


        __block BOOL succeed = NO;
        __block BOOL failed = NO;
        __block NSError *capturedError = nil;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            succeed = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            capturedError = error;
            failed = YES;
        }];

        [operation start];

        [[expectFutureValue(theValue(failed)) shouldEventually] beYes];
        [[capturedError should] equal:[NSError errorWithDomain:@"com.luisobo.nocilla" code:123 userInfo:@{NSLocalizedDescriptionKey:@"Failing, failing... 1, 2, 3...",
                                         @"NSErrorFailingURLKey":[NSURL URLWithString:@"https://example.com/say-hello"],
                                         @"NSErrorFailingURLStringKey":@"https://example.com/say-hello"
                                         }]];

        [[operation.error should] equal:[NSError errorWithDomain:@"com.luisobo.nocilla" code:123 userInfo:@{NSLocalizedDescriptionKey:@"Failing, failing... 1, 2, 3...",
                                                                      @"NSErrorFailingURLKey":[NSURL URLWithString:@"https://example.com/say-hello"],
                                                                      @"NSErrorFailingURLStringKey":@"https://example.com/say-hello"
                                                                      }]];
    });

    it(@"stubs the request with data", ^{
        NSData *requestData = [@"data123" dataUsingEncoding:NSUTF8StringEncoding];
        stubRequest(@"POST", @"https://example.com/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"X-MY-AWESOME-HEADER", @"sisisi").
        withBody(requestData).
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody([@"eeeeooo" dataUsingEncoding:NSUTF8StringEncoding]);

        NSURL *url = [NSURL URLWithString:@"https://example.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:requestData];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation start];

        [operation waitUntilFinished];

        [operation.error shouldBeNil];
        [[operation.responseString should] equal:@"eeeeooo"];
        [[theValue(operation.response.statusCode) should] equal:theValue(200)];
        [[[operation.response.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];

    });
});
SPEC_END