//
//  NSURLRequest+LSHTTPRequest.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 28/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "NSURLRequest+LSHTTPRequest.h"

@implementation NSURLRequest (LSHTTPRequest)

/*
 @property (nonatomic, strong, readonly) NSURL *url;
 @property (nonatomic, strong, readonly) NSString *method;
 @property (nonatomic, strong, readonly) NSDictionary *headers;
 @property (nonatomic, strong, readonly) NSData *body;
 @property (nonatomic, strong, readonly) id<LSHTTPResponse> response;
 */

- (NSURL*) url {
    return self.URL;
}

- (NSString *)method {
    return self.HTTPMethod;
}

- (NSDictionary *)headers {
    return self.allHTTPHeaderFields;
}
- (NSData *)body {
    return self.HTTPBody;
}

@end
