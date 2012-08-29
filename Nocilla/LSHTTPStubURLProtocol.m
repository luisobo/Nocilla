//
//  LSHTTPStubURLProtocol.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 24/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "LSHTTPStubURLProtocol.h"
#import "LSNocilla.h"
#import "NSURLRequest+LSHTTPRequest.h"
#import "LSStubRequest.h"

@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end

@implementation LSHTTPStubURLProtocol

+(BOOL) canInitWithRequest:(NSURLRequest *)request {
    return [@[ @"http", @"https" ] containsObject:request.URL.scheme];
}

+(NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
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
    
    if (!stubbedRequest) {
        [NSException raise:@"Unexpected request" format:@"An unexcepted HTTP request was fired"];
    }
    NSHTTPURLResponse* urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                                 statusCode:stubbedResponse.statusCode
                                                               headerFields:stubbedResponse.headers
                                                                requestTime:0];
    
    [client URLProtocol:self didReceiveResponse:urlResponse
     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:stubbedResponse.body];
    [client URLProtocolDidFinishLoading:self];
}
-(void) stopLoading {
}

@end
