//
//  LSNocilla.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LSNocilla.h"
#import "HTTPServer.h"
#import "LSDynamicConnection.h"

@interface LSNocilla ()
@property (nonatomic, strong) HTTPServer *server;
@property (nonatomic, strong) NSMutableDictionary *mutableRequests;

@end
static LSNocilla *sharedInstace = nil;
@implementation LSNocilla
@synthesize server = _server;
@synthesize mutableRequests = _mutableRequests;

+(LSNocilla *) sharedInstace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mutableRequests = [NSMutableDictionary dictionary];
        self.server = [[HTTPServer alloc] init];
        [self.server setType:@"_http._tcp."];
        // TODO: Make port configurable
        [self.server setPort:12345];
        [self.server setType:@"_http._tcp."];
        [self.server setConnectionClass:[LSDynamicConnection class]];
    }
    return self;
}

- (NSDictionary *)stubbedRequests {
    return [NSDictionary dictionaryWithDictionary:self.mutableRequests];
}

- (void) start {
    NSError *error = nil;
    if (![self.server start:&error]) {
        [NSException raise:NSInternalInconsistencyException format:@"Imposible to start HTTP Server. Error: %@", error];
    }
}

-(void) addStubbedRequest:(LSStubRequest *)request {
    [self.mutableRequests setValue:request forKey:request.url];
}

@end
