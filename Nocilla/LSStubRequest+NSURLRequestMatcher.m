//
//  LSStubRequest+NSURLRequestMatcher.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 26/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "LSStubRequest+NSURLRequestMatcher.h"

@implementation LSStubRequest (MatchesNSURLRequest)

-(BOOL) matchesNSURLRequest:(NSURLRequest *)request {
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