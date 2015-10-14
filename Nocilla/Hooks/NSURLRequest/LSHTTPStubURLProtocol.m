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

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:[NSHTTPCookie cookiesWithResponseHeaderFields:stubbedResponse.headers forURL:request.url]
                       forURL:request.URL mainDocumentURL:request.URL];

    if (stubbedResponse.shouldFail) {
        [client URLProtocol:self didFailWithError:stubbedResponse.error];
    } else {
        NSHTTPURLResponse* urlResponse;
        NSData* body = stubbedResponse.body;
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
        }

        if (stubbedResponse.statusCode < 300 || stubbedResponse.statusCode > 399
            || stubbedResponse.statusCode == 304 || stubbedResponse.statusCode == 305 ) {

            [client URLProtocol:self didReceiveResponse:urlResponse
             cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [client URLProtocol:self didLoadData:body];
            [client URLProtocolDidFinishLoading:self];
        } else {

            NSURL *newURL = [NSURL URLWithString:[stubbedResponse.headers objectForKey:@"Location"] relativeToURL:request.URL];
            NSMutableURLRequest *redirectRequest = [NSMutableURLRequest requestWithURL:newURL];

            [redirectRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[cookieStorage cookiesForURL:newURL]]];

            [client URLProtocol:self
         wasRedirectedToRequest:redirectRequest
               redirectResponse:urlResponse];
            // According to: https://developer.apple.com/library/ios/samplecode/CustomHTTPProtocol/Listings/CustomHTTPProtocol_Core_Code_CustomHTTPProtocol_m.html
            // needs to abort the original request
            [client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];

        }
    }
}

- (void)stopLoading {
}

@end
