#import "Kiwi.h"
#import "LSStubRequest.h"
#import "LSTestRequest.h"
#import "NSString+Nocilla.h"
#import "LSRegexMatcher.h"

SPEC_BEGIN(LSStubRequestSpec)

describe(@"#matchesRequest:", ^{
    context(@"when the method and the URL are equal", ^{
        it(@"should match", ^{
            LSStubRequest *stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            LSTestRequest *other = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [[theValue([stubRequest matchesRequest:other]) should] beYes];
        });
    });
    context(@"when the method is different", ^{
        it(@"should not match", ^{
            LSStubRequest *stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            LSTestRequest *other = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"https://api.example.com/cats/whiskas.json"];
            
            [[theValue([stubRequest matchesRequest:other]) should] beNo];
        });
    });
    context(@"when the URL is different", ^{
        it(@"should not match", ^{
            LSStubRequest *stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            LSTestRequest *other = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/dogs/barky.json"];
            
            [[theValue([stubRequest matchesRequest:other]) should] beNo];
        });
    });

    context(@"when we use a regex matcher for the URL", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *other = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" urlMatcher:[[LSRegexMatcher alloc] initWithRegex:@"^http://foo.com".regex]];
        });
        context(@"the the actual URL matches that regex", ^{
            it(@"matches", ^{
                other = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"http://foo.com/something.json"];

                [[theValue([stubRequest matchesRequest:other]) should] beYes];
            });
        });

        context(@"the the actual URL matches that regex", ^{
            it(@"matches", ^{
                other = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"asdhttp://foo.com"];

                [[theValue([stubRequest matchesRequest:other]) should] beNo];
            });
        });
    });
    
    context(@"when the stub request has a subset of header of the actual request", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            
            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
        });
        describe(@"the stubRequest request", ^{
            it(@"should match the actualRequest request", ^{
                [[theValue([stubRequest matchesRequest:actualRequest]) should] beYes];
            });
        });

    });

    context(@"when the stub request has a perset of headers of the actual request", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];

            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];

            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];

            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
        });
        describe(@"the actualRequest request", ^{
            it(@"should not match the stubRequest request", ^{
                [[theValue([stubRequest matchesRequest:actualRequest]) should] beNo];
            });
        });
    });

    context(@"when the both requests have the same headers", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
        });
        it(@"should match", ^{
            [[theValue([stubRequest matchesRequest:actualRequest]) should] beYes];
        });
    });
    
    context(@"when both requests have the same body", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [stubRequest setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            [actualRequest setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        it(@"should match", ^{
            [[theValue([stubRequest matchesRequest:actualRequest]) should] beYes];
        });
    });
    
    context(@"when both requests have different bodies", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [stubRequest setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            [actualRequest setBody:[@"Adios, this is a body as well" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        it(@"should match", ^{
            [[theValue([stubRequest matchesRequest:actualRequest]) should] beNo];
        });
    });
    
    context(@"when the stubRequest request has a nil body", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [actualRequest setBody:[@"Adios, this is a body as well" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        describe(@"the stubRequest request", ^{
            it(@"should match the actualRequest request", ^{
                [[theValue([stubRequest matchesRequest:actualRequest]) should] beYes];
            });
        });
    });
});

SPEC_END