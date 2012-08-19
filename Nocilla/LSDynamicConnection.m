    //
//  MyHttpConnection.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LSDynamicConnection.h"
#import "HTTPDataResponse.h"
#import "HTTPMessage.h"
#import "LSNocilla.h"

NSString * const LSUnexpectedRequest = @"Unexpected Request";

@implementation LSStubRequest (LSDyamicConnectionMatcher)

-(BOOL)matchesRequest:(HTTPMessage *)request {
    if ([self matchesURL:request]
        && [self matchesHeaders:request]
        && [self matchesBody:request]
        ) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesURL:(HTTPMessage *)request {
    NSString *a = [[NSURL URLWithString:self.url] absoluteString];
    NSString *b = [request.url absoluteString];
    if ([a isEqualToString:b]) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesHeaders:(HTTPMessage *)request {
    for (NSString *header in self.headers) {
        if (![[request headerField:header] isEqualToString:[self.headers objectForKey:header]]) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)matchesBody:(HTTPMessage *)request {
    NSData *selfBody = [self.body dataUsingEncoding:NSUTF8StringEncoding];
    NSData *reqBody = request.body;
    if (!selfBody || [selfBody isEqualToData:reqBody]) {
        return YES;
    }
    return NO;
}

@end

@implementation LSDynamicConnection
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    
    NSArray *requests = [LSNocilla sharedInstace].stubbedRequests;
    
    NSLog(@"Real request:");
    NSLog(@"URL: %@", [request.url absoluteURL]);
    NSLog(@"Method: %@", request.method);
    NSLog(@"Headers: %@", request.allHeaderFields);
    NSLog(@"Body: %@", [[NSString alloc] initWithData:request.body encoding:NSUTF8StringEncoding]);
    
    for (LSStubRequest *stubRequest in requests) {
        
        if ([stubRequest matchesRequest:request]) {
            return stubRequest.response;
        }
    }
    
    [NSException raise:LSUnexpectedRequest format:@"Unexpected request received for url '%@'", [request.url absoluteString]];
    return nil;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
	return YES;
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path {
	if([method isEqualToString:@"POST"])
		return YES;
	
	return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (void)processBodyData:(NSData *)postDataChunk {
	BOOL result = [request appendData:postDataChunk];
	if (!result) {
		NSLog(@"%@[%p]: %@ - Couldn't append bytes!", __FILE__, self, __FUNCTION__
              );
	}
}
@end
