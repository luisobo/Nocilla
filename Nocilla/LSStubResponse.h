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

@class LSStubResponse;

typedef LSStubResponse *(^ResponseWithBodyMethod)(NSString *);
typedef LSStubResponse *(^ResponseWithHeaderMethod)(NSString *, NSString *);
typedef LSStubResponse *(^ResponseWithHeadersMethod)(NSDictionary *);

@interface LSStubResponse : NSObject<LSHTTPResponse>
- (ResponseWithHeaderMethod)withHeader;
- (ResponseWithHeadersMethod)withHeaders;
- (ResponseWithBodyMethod)withBody;

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSData *body;
@property (nonatomic, strong, readonly) NSDictionary *headers;

- (id)initWithStatusCode:(NSInteger)statusCode;
- (id) initDefaultResponse;
@end
