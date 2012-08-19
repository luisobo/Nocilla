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

@implementation LSDynamicConnection
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    
    NSArray *requests = [LSNocilla sharedInstace].stubbedRequests;
    
    NSLog(@"Real request:");
    NSLog(@"URL: %@", [request.url absoluteURL]);
    NSLog(@"Method: %@", request.method);
    NSLog(@"Headers: %@", request.allHeaderFields);
    
    NSData *body = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    for (LSStubRequest *stubRequest in requests) {
        
        NSString *a = [[NSURL URLWithString:stubRequest.url ] absoluteString];
        NSString *b = [request.url absoluteString];
        if ([a isEqualToString:b]) {
            return stubRequest.response;
        }
    }
    
    [NSException raise:LSUnexpectedRequest format:@"Unexpected request received for url '%@'", [request.url absoluteString]];
    NSObject<HTTPResponse> * response = [[HTTPDataResponse alloc] initWithData:body];
    return response;
}
@end
