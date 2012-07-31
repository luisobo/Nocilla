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

@implementation LSDynamicConnection
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    
    NSDictionary *requests = [LSNocilla sharedInstace].stubbedRequests;
    
    NSLog(@"Real request:");
    NSLog(@"URL: %@", [request.url absoluteURL]);
    NSLog(@"Method: %@", request.method);
    NSLog(@"Headers: %@", request.allHeaderFields);
    
    LSStubRequest *stubRequest = [requests objectForKey:[request.url absoluteString
                                                         ]];

    NSLog(@"Stub candidate:");
    NSLog(@"%@", stubRequest);
    
    NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
    return [[HTTPDataResponse alloc] initWithData:data];
}
@end
