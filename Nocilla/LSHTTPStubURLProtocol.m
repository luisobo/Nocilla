//
//  LSHTTPStubURLProtocol.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 24/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "LSHTTPStubURLProtocol.h"
#import "LSNocilla.h"

@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end

@implementation LSStubRequest (MatchesNSURLRequest)

-(BOOL) matches:(NSURLRequest *)request {
    if ([self matchesMethod:request]
        && [self matchesURL:request]
        && [self matchesHeaders:request]
        && [self matchesBody:request]
        ) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesMethod:(NSURLRequest *)request {
    if (!self.method || [self.method isEqualToString:request.HTTPMethod]) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesURL:(NSURLRequest *)request {
    NSString *a = [[NSURL URLWithString:self.url] absoluteString];
    NSString *b = [request.URL absoluteString];
    if ([a isEqualToString:b]) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesHeaders:(NSURLRequest *)request {
    for (NSString *header in self.headers) {
        if (![[[request allHTTPHeaderFields] objectForKey:header] isEqualToString:[self.headers objectForKey:header]]) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)matchesBody:(NSURLRequest *)request {
    NSData *selfBody = [self.body dataUsingEncoding:NSUTF8StringEncoding];
    NSData *reqBody = request.HTTPBody;
    if (!selfBody || [selfBody isEqualToData:reqBody]) {
        return YES;
    }
    return NO;
}

@end

@implementation LSHTTPStubURLProtocol

+(BOOL) canInitWithRequest:(NSURLRequest *)request {
    return [@[ @"http", @"https" ] containsObject:request.URL.scheme];
}

+(NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
	return request;
}

- (void)startLoading {
    NSURLRequest* request = [self request];
	id<NSURLProtocolClient> client = [self client];
    
    LSStubRequest *stubbedRequest = nil;
    LSStubResponse* stubbedResponse = nil;
    NSArray* requests = [LSNocilla sharedInstance].stubbedRequests;
    for(LSStubRequest *someStubbedRequest in requests) {
        if ([someStubbedRequest matches:request]) {
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
