//
//  LSStubResponse.h
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nocilla.h"
#import "HTTPResponse.h"

@class LSStubResponse;

typedef LSStubResponse *(^ResponseWithBodyMethod)(NSString *);
typedef LSStubResponse *(^ResponseWithHeaderMethod)(NSString *, NSString *);

@interface LSStubResponse : NSObject<HTTPResponse>
- (ResponseWithHeaderMethod)withHeader;
- (ResponseWithBodyMethod)withBody;

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSData *body;

-(id) initWithStatusCode:(NSInteger)statusCode;
-(id) initDefaultResponse;
@end
