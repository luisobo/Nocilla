#import "Kiwi.h"
#import "LSHTTPRequest.h"
#import "LSHTTPRequestDiff.h"
#import "LSTestRequest.h"

SPEC_BEGIN(LSHTTPRequestDiffSpec)
describe(@"diffing two LSHTTPRequests", ^{
    __block LSTestRequest *oneRequest = nil;
    __block LSTestRequest *anotherRequest = nil;
    __block LSHTTPRequestDiff *diff = nil;
    context(@"when both represent the same request", ^{
        beforeEach(^{
            NSString *urlString = @"http://www.google.com";
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:urlString];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:urlString];
            diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
        });
        
        it(@"should result in an empty diff", ^{
            [[theValue(diff.isEmpty) should] beYes];
        });
        it(@"should an empty description", ^{
            [[[diff description] should] equal:@""];
        });
    });
    context(@"when the request differ in the method", ^{
        beforeEach(^{
            NSString *urlString = @"http://www.google.com";
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:urlString];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"POST" url:urlString];
        });
        it(@"should not be empty", ^{
            diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            [[theValue(diff.isEmpty) should] beNo];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: GET\n+ Method: POST\n";
                [[[diff description] should] equal:expected];
            });

        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: POST\n+ Method: GET\n";
                [[[diff description] should] equal:expected];
            });

        });
    });
    
    context(@"when the requests differ in the URL", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.luissolano.com"];
        });
        it(@"should not be empty", ^{
            diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            [[theValue(diff.isEmpty) should] beNo];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- URL: http://www.google.com\n+ URL: http://www.luissolano.com\n";
                [[[diff description] should] equal:expected];
            });
        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- URL: http://www.luissolano.com\n+ URL: http://www.google.com\n";
                [[[diff description] should] equal:expected];
            });
        });
    });
    context(@"when the request differ in one header", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            [oneRequest setHeader:@"Content-Type" value:@"application/json"];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
        });
        it(@"should not be empty", ^{
            diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            [[theValue(diff.isEmpty) should] beNo];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"  Headers:\n-\t\"Content-Type\": \"application/json\"\n";
                [[[diff description] should] equal:expected];
            });

        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"  Headers:\n+\t\"Content-Type\": \"application/json\"\n";
                [[[diff description] should] equal:expected];
            });

        });

    });
    
    context(@"when the request differ in one header each", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            [oneRequest setHeader:@"Content-Type" value:@"application/json"];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            [anotherRequest setHeader:@"Accept" value:@"text/plain"];
        });
        it(@"should not be empty", ^{
            diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            [[theValue(diff.isEmpty) should] beNo];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"  Headers:\n-\t\"Content-Type\": \"application/json\"\n+\t\"Accept\": \"text/plain\"\n";
                [[[diff description] should] equal:expected];
            });
        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"  Headers:\n-\t\"Accept\": \"text/plain\"\n+\t\"Content-Type\": \"application/json\"\n";
                [[[diff description] should] equal:expected];
            });

        });
    });
    context(@"when the requests differ in the body", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            oneRequest.body = [@"this is a body" dataUsingEncoding:NSUTF8StringEncoding];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
        });
        it(@"should not be empty", ^{
            diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            [[theValue(diff.isEmpty) should] beNo];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Body: \"this is a body\"\n";
                [[[diff description] should] equal:expected];
            });
        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"+ Body: \"this is a body\"\n";

                [[[diff description] should] equal:expected];
            });

        });
    });
    context(@"when the requests differ in the Method and the URL", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"http://www.luissolano.com"];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: GET\n+ Method: PUT\n- URL: http://www.google.com\n+ URL: http://www.luissolano.com\n";
                [[[diff description] should] equal:expected];
            });
        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: PUT\n+ Method: GET\n- URL: http://www.luissolano.com\n+ URL: http://www.google.com\n";
                [[[diff description] should] equal:expected];
            });

        });
    });
    context(@"when the request differ in the Method, URL and headers", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://www.google.es"];
            [oneRequest setHeader:@"X-API-TOKEN" value:@"123456789"];
            [oneRequest setHeader:@"Accept" value:@"application/json"];
            [oneRequest setHeader:@"X-Custom-Header" value:@"Really??"];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"DELETE" url:@"http://www.luissolano.com/ispellchecker/"];
            [anotherRequest setHeader:@"Accept" value:@"application/json"];
            [anotherRequest setHeader:@"X-API-TOKEN" value:@"abcedfghi"];
            [anotherRequest setHeader:@"X-APP-ID" value:@"Nocilla"];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: POST\n+ Method: DELETE\n- URL: http://www.google.es\n+ URL: http://www.luissolano.com/ispellchecker/\n  Headers:\n-\t\"X-API-TOKEN\": \"123456789\"\n-\t\"X-Custom-Header\": \"Really??\"\n+\t\"X-API-TOKEN\": \"abcedfghi\"\n+\t\"X-APP-ID\": \"Nocilla\"\n";
                [[[diff description] should] equal:expected];
            });
        });
        context(@"in the other direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest];
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: DELETE\n+ Method: POST\n- URL: http://www.luissolano.com/ispellchecker/\n+ URL: http://www.google.es\n  Headers:\n-\t\"X-API-TOKEN\": \"abcedfghi\"\n-\t\"X-APP-ID\": \"Nocilla\"\n+\t\"X-API-TOKEN\": \"123456789\"\n+\t\"X-Custom-Header\": \"Really??\"\n";
                [[[diff description] should] equal:expected];
            });
        });
    });
    context(@"when the requests differ in everything", ^{
        beforeEach(^{
            oneRequest = [[LSTestRequest alloc] initWithMethod:@"PUT" url:@"https://www.google.it"];
            [oneRequest setHeader:@"X-API-TOKEN" value:@"123456789"];
            [oneRequest setHeader:@"Accept" value:@"application/json"];
            [oneRequest setHeader:@"X-Custom-Header" value:@"Really??"];
            [oneRequest setBody:[@"This is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            anotherRequest = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.luissolano.com"];
            [anotherRequest setHeader:@"X-API-TOKEN" value:@"123456789"];
            [anotherRequest setHeader:@"X-APP-ID" value:@"Nocilla"];
            [anotherRequest setBody:[@"This is THE body" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        context(@"in one direction", ^{
            beforeEach(^{
                diff = [[LSHTTPRequestDiff alloc] initWithRequest:oneRequest andRequest:anotherRequest]; 
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: PUT\n+ Method: GET\n- URL: https://www.google.it\n+ URL: http://www.luissolano.com\n  Headers:\n-\t\"Accept\": \"application/json\"\n-\t\"X-Custom-Header\": \"Really??\"\n+\t\"X-APP-ID\": \"Nocilla\"\n- Body: \"This is a body\"\n+ Body: \"This is THE body\"\n";
                [[[diff description] should] equal:expected];
            });
        });
        context(@"in the other direction", ^{
            beforeEach(^{
               diff = [[LSHTTPRequestDiff alloc] initWithRequest:anotherRequest andRequest:oneRequest]; 
            });
            it(@"should have a description representing the diff", ^{
                NSString *expected = @"- Method: GET\n+ Method: PUT\n- URL: http://www.luissolano.com\n+ URL: https://www.google.it\n  Headers:\n-\t\"X-APP-ID\": \"Nocilla\"\n+\t\"Accept\": \"application/json\"\n+\t\"X-Custom-Header\": \"Really??\"\n- Body: \"This is THE body\"\n+ Body: \"This is a body\"\n";
                [[[diff description] should] equal:expected];
            });
        });
    });
});
SPEC_END