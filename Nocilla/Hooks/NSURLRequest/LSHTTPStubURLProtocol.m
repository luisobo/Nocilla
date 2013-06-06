#import "LSHTTPStubURLProtocol.h"
#import "LSNocilla.h"
#import "NSURLRequest+LSHTTPRequest.h"
#import "LSStubRequest.h"
#import "NSURLRequest+DSL.h"

@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end

@implementation LSHTTPStubURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [@[ @"http", @"https" ] containsObject:request.URL.scheme];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
	return request;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}

- (void)startLoading {
    NSURLRequest* request = [self request];
	id<NSURLProtocolClient> client = [self client];
    
    LSStubRequest *stubbedRequest = nil;
    LSStubResponse* stubbedResponse = nil;
    NSArray* requests = [LSNocilla sharedInstance].stubbedRequests;
    
    for(LSStubRequest *someStubbedRequest in requests) {
        if ([someStubbedRequest matchesRequest:request]) {
            stubbedRequest = someStubbedRequest;
            stubbedResponse = stubbedRequest.response;
            break;
        }
    }
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *body = nil;
    if (stubbedRequest) {
        if(stubbedRequest.responseTime > 0) {
            [NSThread sleepForTimeInterval:stubbedRequest.responseTime];
        }
        urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                                 statusCode:stubbedResponse.statusCode
                                                               headerFields:stubbedResponse.headers
                                                                requestTime:0];
        body = stubbedResponse.body;
    } else {

        [NSException raise:@"NocillaUnexpectedRequest" format:@"An unexpected HTTP request was fired.\n\nUse this snippet to stub the request:\n%@\n", [request toNocillaDSL]];
    }
    [client URLProtocol:self didReceiveResponse:urlResponse
     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:body];
    [client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
}

@end
