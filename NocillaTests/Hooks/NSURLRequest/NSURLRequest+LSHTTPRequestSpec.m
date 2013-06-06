#import "Kiwi.h"
#import "NSURLRequest+LSHTTPRequest.h"

SPEC_BEGIN(NSURLRequest_LSHTTPRequestSpec)

describe(@"-body", ^{
    __block NSURLRequest *request;

    context(@"when the request provides a body stream", ^{
        __block NSString *stringUrl = @"http://api.example.com/dogs.xml";
        __block NSData *requestBody = [@"arg1=foo&arg2=bar" dataUsingEncoding:NSUTF8StringEncoding];

        beforeEach(^{
            NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
            mutableRequest.HTTPBodyStream = [NSInputStream inputStreamWithData:requestBody];
            request = mutableRequest;
        });

        it(@"uses the entire stream as the body", ^{
            [[[request body] should] equal:requestBody];
        });
    });
});

SPEC_END
