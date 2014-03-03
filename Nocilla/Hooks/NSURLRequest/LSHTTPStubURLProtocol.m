#import "LSHTTPBody.h"
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

    LSStubResponse* stubbedResponse = [[LSNocilla sharedInstance] responseForRequest:request];

    if (stubbedResponse.shouldFail) {
        [client URLProtocol:self didFailWithError:stubbedResponse.error];
    } else {
        NSHTTPURLResponse* urlResponse;
        id<LSHTTPBody> body = nil;
        if (stubbedResponse.blockResponse) {
            NSDictionary *headers = stubbedResponse.headers;
            NSInteger status = stubbedResponse.statusCode;
            stubbedResponse.blockResponse(&headers, &status, &body);
            urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                      statusCode:status
                                                    headerFields:headers
                                                     requestTime:0];
        } else {
            urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                      statusCode:stubbedResponse.statusCode
                                                    headerFields:stubbedResponse.headers
                                                     requestTime:0];
            body = stubbedResponse.body;
        }

        [client URLProtocol:self didReceiveResponse:urlResponse
         cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [client URLProtocol:self didLoadData:body.data];
        [client URLProtocolDidFinishLoading:self];
    }
}

- (void)stopLoading {
}

@end
