#import "Kiwi.h"
#import "Nocilla.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LSASIHTTPRequestHook.h"

SPEC_BEGIN(ASIHTTPRequestStubbingSpec)

beforeEach(^{
    [[LSNocilla sharedInstance] registerHook:[[LSASIHTTPRequestHook alloc] init]];
    [[LSNocilla sharedInstance] start];
});

afterEach(^{
    [[LSNocilla sharedInstance] stop];
    [[LSNocilla sharedInstance] clearStubs];
});

it(@"stubs a GET request", ^{
    stubRequest(@"GET", @"http://httpstat.us/400").
    andReturn(201).
    withHeaders(@{@"Header 1":@"Foo", @"Header 2":@"Bar"}).
    withBody(@"Holaa!");

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://httpstat.us/400"]];

    [request startAsynchronous];

    [request waitUntilFinished];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
    [[request.responseString should] equal:@"Holaa!"];
    [[request.responseData should] equal:[@"Holaa!" dataUsingEncoding:NSUTF8StringEncoding]];
    [[request.responseHeaders should] equal:@{@"Header 1":@"Foo", @"Header 2":@"Bar"}];
    [[theValue(request.isFinished) should] beYes];

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

    [request waitUntilFinished];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
    [[request.responseString should] equal:@"Holaa!"];
    [[request.responseData should] equal:[@"Holaa!" dataUsingEncoding:NSUTF8StringEncoding]];
    [[request.responseHeaders should] equal:@{@"Header 1":@"Foo", @"Header 2":@"Bar"}];
    [[theValue(request.isFinished) should] beYes];
});

it(@"fails a request", ^{
    NSError *error = [NSError nullMock];
    stubRequest(@"POST", @"http://api.example.com/v1/cats").
    withHeaders(@{@"Authorization":@"Basic 667788"}).
    withBody(@"name=calcetines&color=black").
    andFailWithError(error);

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://api.example.com/v1/cats"]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Authorization" value:@"Basic 667788"];
    [request addPostValue:@"calcetines" forKey:@"name"];
    [request addPostValue:@"black" forKey:@"color"];

    [request startAsynchronous];

    [request waitUntilFinished];

    [[expectFutureValue(request.error) shouldEventually] beIdenticalTo:error];
    [[theValue(request.isFinished) should] beYes];
});

it(@"stubs an HTTPS request", ^{
    stubRequest(@"GET", @"https://example.com/things").
    andReturn(201).
    withHeaders(@{@"Header 1":@"Foo", @"Header 2":@"Bar"}).
    withBody(@"Holaa!");

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://example.com/things"]];

    [request startAsynchronous];

    [request waitUntilFinished];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
    [[request.responseString should] equal:@"Holaa!"];
    [[request.responseData should] equal:[@"Holaa!" dataUsingEncoding:NSUTF8StringEncoding]];
    [[request.responseHeaders should] equal:@{@"Header 1":@"Foo", @"Header 2":@"Bar"}];
    [[theValue(request.isFinished) should] beYes];
});

it(@"stubs a ASIFormDataRequest", ^{
    stubRequest(@"POST", @"http://api.example.com/v1/cats").
    withHeaders(@{@"Authorization":@"Basic 667788"}).
    withBody(@"name=calcetines&color=black").
    andReturn(201).
    withHeaders(@{@"Header 1":@"Foo", @"Header 2":@"Bar"}).
    withBody(@"Holaa!");

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://api.example.com/v1/cats"]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Authorization" value:@"Basic 667788"];
    [request addPostValue:@"calcetines" forKey:@"name"];
    [request addPostValue:@"black" forKey:@"color"];
    

    [request startAsynchronous];

    [request waitUntilFinished];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
    [[request.responseString should] equal:@"Holaa!"];
    [[request.responseData should] equal:[@"Holaa!" dataUsingEncoding:NSUTF8StringEncoding]];
    [[request.responseHeaders should] equal:@{@"Header 1":@"Foo", @"Header 2":@"Bar"}];
    [[theValue(request.isFinished) should] beYes];
});

SPEC_END