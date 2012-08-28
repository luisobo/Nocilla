//
//  LSStubResponse.h
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nocilla.h"
#import "LSHTTPResponse.h"

@interface LSStubResponse : NSObject<LSHTTPResponse>

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong) NSData *body;
@property (nonatomic, strong, readonly) NSDictionary *headers;

- (id)initWithStatusCode:(NSInteger)statusCode;
- (id) initDefaultResponse;
- (void)setHeader:(NSString *)header value:(NSString *)value;
@end
