#import "Kiwi.h"
#import "LSStubRequest.h"
#import "LSTestRequest.h"
#import "NSString+Nocilla.h"
#import "LSRegexMatcher.h"
#import "LSDataMatcher.h"
#import "LSStringMatcher.h"

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

            LSDataMatcher *bodyMatcher = [[LSDataMatcher alloc] initWithData:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            [stubRequest setBody:bodyMatcher];
            [actualRequest setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        it(@"should match", ^{
            [[theValue([stubRequest matchesRequest:actualRequest]) should] beYes];
        });
    });

    context(@"when using a matching regex to match the body", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];

            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];

            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];

            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];

            LSRegexMatcher *bodyMatcher = [[LSRegexMatcher alloc] initWithRegex:[NSRegularExpression regularExpressionWithPattern:@"^Hola" options:0 error:nil]];
            [stubRequest setBody:bodyMatcher];
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

            LSDataMatcher *bodyMatcher = [[LSDataMatcher alloc] initWithData:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            [stubRequest setBody:bodyMatcher];
            [actualRequest setBody:[@"Adios, this is a body as well" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        it(@"should match", ^{
            [[theValue([stubRequest matchesRequest:actualRequest]) should] beNo];
        });
    });

    context(@"when using a regex that does no match to match the body", ^{
        __block LSStubRequest *stubRequest = nil;
        __block LSTestRequest *actualRequest = nil;
        beforeEach(^{
            stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];

            actualRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];

            [stubRequest setHeader:@"Content-Type" value:@"application/json"];
            [stubRequest setHeader:@"X-API-TOKEN" value:@"123abc"];

            [actualRequest setHeader:@"Content-Type" value:@"application/json"];
            [actualRequest setHeader:@"X-API-TOKEN" value:@"123abc"];

            LSRegexMatcher *bodyMatcher = [[LSRegexMatcher alloc] initWithRegex:[NSRegularExpression regularExpressionWithPattern:@"^Hola" options:0 error:nil]];
            [stubRequest setBody:bodyMatcher];
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

describe(@"isEqual:", ^{
    it(@"is equal to a stub with the same method, url, headers and body", ^{
        // It may appear that there is needless duplication of matcher objects in this tests,
        // however this is intended as we need to ensure the properties of the stub request
        // are truly equal by value, not just equal pointers.

        LSRegexMatcher *urlA = [[LSRegexMatcher alloc] initWithRegex:@"https://(.+)\\.example\\.com/(.+)/data\\.json".regex];
        LSStubRequest *stubA = [[LSStubRequest alloc] initWithMethod:@"GET" urlMatcher:urlA];
        LSRegexMatcher *urlB = [[LSRegexMatcher alloc] initWithRegex:@"https://(.+)\\.example\\.com/(.+)/data\\.json".regex];
        LSStubRequest *stubB = [[LSStubRequest alloc] initWithMethod:@"GET" urlMatcher:urlB];

        stubA.body = [[LSRegexMatcher alloc] initWithRegex:@"checkout my sexy body ([a-z]+?)".regex];
        stubB.body = [[LSRegexMatcher alloc] initWithRegex:@"checkout my sexy body ([a-z]+?)".regex];

        [stubA setHeader:@"Content-Type" value:@"application/json"];
        [stubB setHeader:@"Content-Type" value:@"application/json"];

        [[stubA should] equal:stubB];
    });

    it(@"is not equal with a different method", ^{
        LSStubRequest *stubA = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];
        LSStubRequest *stubB = [[LSStubRequest alloc] initWithMethod:@"POST" url:@"google.com"];

        [[stubA shouldNot] equal:stubB];
    });

    it(@"is not equal with a different url matcher", ^{
        LSRegexMatcher *urlA = [[LSRegexMatcher alloc] initWithRegex:@"https://(.+)\\.example\\.com/(.+)/data\\.json".regex];
        LSStubRequest *stubA = [[LSStubRequest alloc] initWithMethod:@"GET" urlMatcher:urlA];
        LSRegexMatcher *urlB = [[LSRegexMatcher alloc] initWithRegex:@"https://github\\.com/(.+)/(.+)/".regex];
        LSStubRequest *stubB = [[LSStubRequest alloc] initWithMethod:@"GET" urlMatcher:urlB];

        [[stubA shouldNot] equal:stubB];
    });

    it(@"is not equal with different headers", ^{
        LSStubRequest *stubA = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];
        LSStubRequest *stubB = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];

        [stubA setHeader:@"Content-Type" value:@"application/json"];
        [stubB setHeader:@"Content-Type" value:@"application/json"];

        [stubA setHeader:@"X-OMG" value:@"nothings compares"];
        [stubB setHeader:@"X-DIFFERENT" value:@"to you"];

        [[stubA shouldNot] equal:stubB];
    });

    it(@"is not equal with a different body", ^{
        LSStubRequest *stubA = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];
        LSStubRequest *stubB = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];

        stubA.body = [[LSStringMatcher alloc] initWithString:@"omg"];
        stubB.body = [[LSStringMatcher alloc] initWithString:@"different"];

        [[stubA shouldNot] equal:stubB];
    });

    it(@"is equal with a nil bodies", ^{
        // Body is special in that it's the only propery that may be nil,
        // and [nil isEqual:nil] returns NO.

        LSStubRequest *stubA = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];
        LSStubRequest *stubB = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"google.com"];

        stubA.body = nil;
        stubB.body = nil;

        [[stubA should] equal:stubB];
    });
});

SPEC_END