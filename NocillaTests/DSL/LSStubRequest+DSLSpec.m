#import "Kiwi.h"
#import "LSStubRequest.h"
#import "LSStubRequest+DSLAdditions.h"

SPEC_BEGIN(LSStubRequest_DSLSpec)
describe(@"#toDSL", ^{
    __block LSStubRequest *request = nil;
    describe(@"a request with a GET method and url", ^{
        beforeEach(^{
            request = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
        });
        it(@"should return the DSL representation", ^{
            [[[request toDSL] should] equal:@"stubRequest(@\"GET\", @\"http://www.google.com\");"];
        });
    });
    describe(@"a request with a POST method and a url", ^{
        beforeEach(^{
            request = [[LSStubRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
        });
        it(@"should return the DSL representation", ^{
            [[[request toDSL] should] equal:@"stubRequest(@\"POST\", @\"http://luissolano.com\");"];
        });
    });
    describe(@"a request with one header", ^{
        beforeEach(^{
            request = [[LSStubRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
            [request setHeader:@"Accept" value:@"text/plain"];
            
        });
        it(@"should return the DSL representation", ^{
            [[[request toDSL] should] equal:@"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithHeaders(@{ @\"Accept\": @\"text/plain\" });"];
        });
    });
    describe(@"a request with 3 headers", ^{
        beforeEach(^{
            request = [[LSStubRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
            [request setHeader:@"Accept" value:@"text/plain"];
            [request setHeader:@"Content-Length" value:@"18"];
            [request setHeader:@"If-Match" value:@"a8fhw0dhasd03qn02"];
            
        });
        it(@"should return the DSL representation", ^{
            NSString *expected = @"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithHeaders(@{ @\"Accept\": @\"text/plain\", @\"Content-Length\": @\"18\", @\"If-Match\": @\"a8fhw0dhasd03qn02\" });";
            NSLog(@"actual:\n%@", [request toDSL]);
            NSLog(@"expected:\n%@", expected);
            [[[request toDSL] should] equal:expected];
        });
    });
});
SPEC_END