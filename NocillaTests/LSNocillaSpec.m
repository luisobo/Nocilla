#import "Kiwi.h"
#import "LSNocilla.h"
#import "LSStubRequest.h"
#import "LSStubResponse.h"
#import "LSRegexMatcher.h"

SPEC_BEGIN(LSNocillaSpec)

describe(@"-responseForRequest:", ^{
    context(@"when the specified request matches a previously stubbed request", ^{
        it(@"returns the associated response", ^{
            LSStubRequest *stubbedRequest = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
            LSStubResponse *stubbedResponse = [[LSStubResponse alloc] initWithStatusCode:403];
            stubbedRequest.response = stubbedResponse;
            [[LSNocilla sharedInstance] addStubbedRequest:stubbedRequest];

            NSObject<LSHTTPRequest> *actualRequest = [KWMock nullMockForProtocol:@protocol(LSHTTPRequest)];
            [actualRequest stub:@selector(url) andReturn:[NSURL URLWithString:@"http://www.google.com"]];
            [actualRequest stub:@selector(method) andReturn:@"GET"];

            LSStubResponse *result = [[LSNocilla sharedInstance] responseForRequest:actualRequest];

            [[result should] equal:stubbedResponse];

            [[LSNocilla sharedInstance] clearStubs];
        });
    });

    context(@"when the specified request does not match any stubbed request", ^{
        it(@"raises an exception with a descriptive error message ", ^{
            NSObject<LSHTTPRequest> *actualRequest = [KWMock nullMockForProtocol:@protocol(LSHTTPRequest)];
            [actualRequest stub:@selector(url) andReturn:[NSURL URLWithString:@"http://www.google.com"]];
            [actualRequest stub:@selector(method) andReturn:@"GET"];


            NSString *expectedMessage = @"An unexpected HTTP request was fired.\n\nUse this snippet to stub the request:\nstubRequest(@\"GET\", @\"http://www.google.com\");\n";
            [[theBlock(^{
                [[LSNocilla sharedInstance] responseForRequest:actualRequest];
            }) should] raiseWithName:@"NocillaUnexpectedRequest" reason:expectedMessage];

            [[LSNocilla sharedInstance] clearStubs];
        });
    });

	context(@"when the specified request was called to often", ^{
		it(@"raises an exception with a descriptive error message ", ^{
			LSStubRequest *stubbedRequest = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
			stubbedRequest.expectedCallCount = @(1);
			[[LSNocilla sharedInstance] addStubbedRequest:stubbedRequest];

			NSObject<LSHTTPRequest> *actualRequest = [KWMock nullMockForProtocol:@protocol(LSHTTPRequest)];
			[actualRequest stub:@selector(url) andReturn:[NSURL URLWithString:@"http://www.google.com"]];
			[actualRequest stub:@selector(method) andReturn:@"GET"];

			[[LSNocilla sharedInstance] countRequest:actualRequest];

			NSString *expectedMessage =  @"An unexpected HTTP request to \"http://www.google.com\" was fired.\nYou already "
					"stubbed this request but it should be fired 1 times but was fired 2 times.\n";
			[[theBlock(^{
				[[LSNocilla sharedInstance] countRequest:actualRequest];
			}) should] raiseWithName:@"NocillaUnexpectedRequest" reason:expectedMessage];

			[[LSNocilla sharedInstance] clearStubs];
		});
	});

	context(@"when one wants to verify the call count", ^{
		__block NSObject<LSHTTPRequest> *actualRequest;
		beforeEach(^{
			actualRequest = [KWMock nullMockForProtocol:@protocol(LSHTTPRequest)];
			[actualRequest stub:@selector(url) andReturn:[NSURL URLWithString:@"http://www.google.com"]];
			[actualRequest stub:@selector(method) andReturn:@"GET"];
		});

		afterEach(^{
			[[LSNocilla sharedInstance] clearStubs];
		});

		it(@"ignores requests without an expected call count", ^{
			LSStubRequest *stubbedRequest = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
			[[LSNocilla sharedInstance] addStubbedRequest:stubbedRequest];

			[[LSNocilla sharedInstance] countRequest:actualRequest];

			[[LSNocilla sharedInstance] verifyCallCount];

		});

		it(@"raises no exception if the request was called exactly as often as expected", ^{
			LSStubRequest *stubbedRequest = [[LSStubRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
			stubbedRequest.expectedCallCount = @(1);
			[[LSNocilla sharedInstance] addStubbedRequest:stubbedRequest];

			[[LSNocilla sharedInstance] countRequest:actualRequest];

			[[LSNocilla sharedInstance] verifyCallCount];
		});

		it(@"raises an expection if the request was called less often than expected", ^{
			LSRegexMatcher *regexMatcher = [[LSRegexMatcher alloc] initWithRegex:@"http://www.(.*).com".regex];
			LSStubRequest *stubbedRequest = [[LSStubRequest alloc] initWithMethod:@"GET" urlMatcher:regexMatcher];
			stubbedRequest.expectedCallCount = @(2);
			[[LSNocilla sharedInstance] addStubbedRequest:stubbedRequest];

			[[LSNocilla sharedInstance] countRequest:actualRequest];

			[[theBlock(^{
				[[LSNocilla sharedInstance] verifyCallCount];
			}) should] raiseWithName:@"NocillaMissingRequest" reason:@"The request to \"http://www.(.*).com\" should be fired 2 times but was fired 1 times"
					".\n"];
		});
	});
});

SPEC_END