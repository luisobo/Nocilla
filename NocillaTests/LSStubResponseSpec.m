#import "Kiwi.h"
#import "LSStubResponse.h"

SPEC_BEGIN(LSStubResponseSpec)

describe(@"#initWithRawResponse:", ^{
    context(@"when the input data is a complete raw response", ^{
        it(@"should have the correct statusCode, headers and body", ^{
            NSData *rawData = [@"HTTP/1.1 201 created\nContent-Type: application/json; charset=utf-8\nConnection: keep-alive\n\n{\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding];
            LSStubResponse *stubResponse = [[LSStubResponse alloc] initWithRawResponse:rawData];
            
            [[theValue(stubResponse.statusCode) should] equal:theValue(201)];
            [[stubResponse.headers should] equal:[NSDictionary dictionaryWithObjectsAndKeys:@"application/json; charset=utf-8", @"Content-Type",
                                                  @"keep-alive", @"Connection", nil]];
            [[stubResponse.body should] equal:[@"{\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding]];
        });
    });
    
    context(@"when the input data is a just the raw body", ^{
        it(@"should have the correct body with default status code and headers", ^{
            NSData *rawData = [@"{\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding];
            LSStubResponse *stubResponse = [[LSStubResponse alloc] initWithRawResponse:rawData];
            
            [[theValue(stubResponse.statusCode) should] equal:theValue(200)];
            [[stubResponse.headers should] equal:[NSDictionary dictionary]];
            [[stubResponse.body should] equal:[@"{\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding]];
        });
    });

    context(@"when the responseCode is a 3xx redirect", ^{
        it(@"should provide an suitable redirect request", ^{
            LSStubResponse *stubResponse = [[LSStubResponse alloc] initWithStatusCode:301];
            [stubResponse setHeader:@"Location" value:@"redirect.html"];

            NSURLRequest *redirectRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"redirect.html"]];
            [[stubResponse.redirectRequest should] equal:redirectRequest];
        });
    });
});

SPEC_END