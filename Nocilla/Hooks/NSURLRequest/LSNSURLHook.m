//
//  LSNSURLHook.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 24/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "LSNSURLHook.h"
#import "LSHTTPStubURLProtocol.h"

@implementation LSNSURLHook

-(void) load {
    [NSURLProtocol registerClass:[LSHTTPStubURLProtocol class]];
}

@end
