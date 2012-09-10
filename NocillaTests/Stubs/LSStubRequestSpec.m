#import "Kiwi.h"
#import "LSStubRequest.h"

SPEC_BEGIN(LSStubRequestSpec)

describe(@"#matchesRequest:", ^{
    context(@"when the method and the URL are equal", ^{
        it(@"should match", ^{
            LSStubRequest *stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            LSStubRequest *other = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [[theValue([stubRequest matchesRequest:other]) should] beYes];
            [[theValue([other matchesRequest:stubRequest]) should] beYes];
        });
    });
    context(@"when the method is different", ^{
        it(@"should not match", ^{
            LSStubRequest *stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            LSStubRequest *other = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"https://api.example.com/cats/whiskas.json"];
            
            [[theValue([stubRequest matchesRequest:other]) should] beNo];
            [[theValue([other matchesRequest:stubRequest]) should] beNo];
        });
    });
    context(@"when the URL is different", ^{
        it(@"should not match", ^{
            LSStubRequest *stubRequest = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            LSStubRequest *other = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/dogs/barky.json"];
            
            [[theValue([stubRequest matchesRequest:other]) should] beNo];
            [[theValue([other matchesRequest:stubRequest]) should] beNo];
        });
    });
    
    context(@"when the left request has a subset of header of the right request", ^{
        __block LSStubRequest *left = nil;
        __block LSStubRequest *right = nil;
        beforeEach(^{
            left = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            right = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [left setHeader:@"Content-Type" value:@"application/json"];
            
            [right setHeader:@"Content-Type" value:@"application/json"];
            [right setHeader:@"X-API-TOKEN" value:@"123abc"];
        });
        describe(@"the left request", ^{
            it(@"should match the right request", ^{
                [[theValue([left matchesRequest:right]) should] beYes];
            });
        });
        describe(@"the right request", ^{
            it(@"should not match the left request", ^{
                [[theValue([right matchesRequest:left]) should] beNo];
            });
        });
    });
    context(@"when the both requests have the same headers", ^{
        __block LSStubRequest *left = nil;
        __block LSStubRequest *right = nil;
        beforeEach(^{
            left = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            right = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [left setHeader:@"Content-Type" value:@"application/json"];
            [left setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [right setHeader:@"Content-Type" value:@"application/json"];
            [right setHeader:@"X-API-TOKEN" value:@"123abc"];
        });
        it(@"should match each other", ^{
            [[theValue([left matchesRequest:right]) should] beYes];
            [[theValue([right matchesRequest:left]) should] beYes];
        });
    });
    
    context(@"when both requests have the same body", ^{
        __block LSStubRequest *left = nil;
        __block LSStubRequest *right = nil;
        beforeEach(^{
            left = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            right = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [left setHeader:@"Content-Type" value:@"application/json"];
            [left setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [right setHeader:@"Content-Type" value:@"application/json"];
            [right setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [left setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            [right setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        it(@"should match each other", ^{
            [[theValue([left matchesRequest:right]) should] beYes];
            [[theValue([right matchesRequest:left]) should] beYes];
        });
    });
    
    context(@"when both requests have different bodies", ^{
        __block LSStubRequest *left = nil;
        __block LSStubRequest *right = nil;
        beforeEach(^{
            left = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            right = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [left setHeader:@"Content-Type" value:@"application/json"];
            [left setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [right setHeader:@"Content-Type" value:@"application/json"];
            [right setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [left setBody:[@"Hola, this is a body" dataUsingEncoding:NSUTF8StringEncoding]];
            [right setBody:[@"Adios, this is a body as well" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        it(@"should match each other", ^{
            [[theValue([left matchesRequest:right]) should] beNo];
            [[theValue([right matchesRequest:left]) should] beNo];
        });
    });
    
    context(@"when the left request has a nil body", ^{
        __block LSStubRequest *left = nil;
        __block LSStubRequest *right = nil;
        beforeEach(^{
            left = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            right = [[LSStubRequest alloc] initWithMethod:@"PUT" url:@"https://api.example.com/cats/whiskas.json"];
            
            [left setHeader:@"Content-Type" value:@"application/json"];
            [left setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [right setHeader:@"Content-Type" value:@"application/json"];
            [right setHeader:@"X-API-TOKEN" value:@"123abc"];
            
            [right setBody:[@"Adios, this is a body as well" dataUsingEncoding:NSUTF8StringEncoding]];
        });
        describe(@"the left request", ^{
            it(@"should match the right request", ^{
                [[theValue([left matchesRequest:right]) should] beYes];
            });
        });
        describe(@"the right request", ^{
            it(@"should not match the left request", ^{
                [[theValue([right matchesRequest:left]) should] beNo];
            });
        });
    });
});

SPEC_END