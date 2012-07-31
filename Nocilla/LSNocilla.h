//
//  LSNocilla.h
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nocilla.h"

@class LSStubRequest;

@interface LSNocilla : NSObject
+(LSNocilla *) sharedInstace;
@property (nonatomic, strong, readonly) NSDictionary *stubbedRequests;
-(void) start;
-(void) addStubbedRequest:(LSStubRequest *)request;
@end
