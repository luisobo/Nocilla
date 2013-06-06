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

it(@"should stub the request", ^{
    stubRequest(@"GET", @"http://httpstat.us/400").andReturn(201);

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://httpstat.us/400"]];

    [request startAsynchronous];

    [[expectFutureValue(theValue(request.responseStatusCode)) shouldEventually] equal:theValue(201)];
});

SPEC_END