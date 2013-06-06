#import "Kiwi.h"
#import "Nocilla.h"
#import "ASIHTTPRequest.h"

SPEC_BEGIN(ASIHTTPRequestStubbingSpec)

beforeAll(^{
    [[LSNocilla sharedInstance] start];
});

afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});

afterAll(^{
    [[LSNocilla sharedInstance] stop];
});

it(@"stubs a GET request", ^{
    stubRequest(@"GET", @"http://httpstat.us/400").
    andReturn(201).
    withHeaders(@{@"Header 1":@"Foo", @"Header 2":@"Bar"}).
    withBody(@"Holaa!");

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://httpstat.us/400"]];

    [request startAsynchronous];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
    [[request.responseString should] equal:@"Holaa!"];
    [[request.responseData should] equal:[@"Holaa!" dataUsingEncoding:NSUTF8StringEncoding]];
    [[request.responseHeaders should] equal:@{@"Header 1":@"Foo", @"Header 2":@"Bar"}];

});

it(@"stubs a POST request", ^{
    stubRequest(@"POST", @"http://api.example.com/v1/dogs.json").
    withHeaders(@{@"Authorization":@"Bearer 123123123"}).
    withBody(@"{\"dog\":\"pepu\"}").
    andReturn(201).
    withHeaders(@{@"Header 1":@"Foo", @"Header 2":@"Bar"}).
    withBody(@"Holaa!");

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://api.example.com/v1/dogs.json"]];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Authorization" value:@"Bearer 123123123"];
    [request appendPostData:[@"{\"dog\":\"pepu\"}" dataUsingEncoding:NSUTF8StringEncoding]];

    [request startAsynchronous];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
    [[request.responseString should] equal:@"Holaa!"];
    [[request.responseData should] equal:[@"Holaa!" dataUsingEncoding:NSUTF8StringEncoding]];
    [[request.responseHeaders should] equal:@{@"Header 1":@"Foo", @"Header 2":@"Bar"}];
});


SPEC_END