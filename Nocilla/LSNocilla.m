//
//  LSNocilla.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LSNocilla.h"
#import "HTTPServer.h"
#import "LSHTTPStubberConnection.h"
#import "LSHTTPSStubberConnection.h"
#import "LSMethodSwizzler.h"

@interface LSNocilla ()
@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic, strong) HTTPServer *httpsServer;
@property (nonatomic, strong) NSMutableArray *mutableRequests;

-(void) loadAdapters;
-(void) loadASIHTTPRequestAdapater;

@end
static LSNocilla *sharedInstace = nil;
@implementation LSNocilla


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
        self.mutableRequests = [NSMutableArray array];
        self.httpServer = [[HTTPServer alloc] init];
        [self.httpServer setType:@"_http._tcp."];
        // TODO: Make port configurable
        [self.httpServer setPort:12345];
        [self.httpServer setType:@"_http._tcp."];
        [self.httpServer setConnectionClass:[LSHTTPStubberConnection class]];
        
        self.httpsServer = [[HTTPServer alloc] init];
        [self.httpsServer setType:@"_http._tcp."];
        // TODO: Make port configurable
        [self.httpsServer setPort:12346];
        [self.httpsServer setConnectionClass:[LSHTTPSStubberConnection class]];
        
    }
    return self;
}

- (NSArray *)stubbedRequests {
    return [NSArray arrayWithArray:self.mutableRequests];
}

- (void) start {
    NSError *error = nil;
    if (![self.httpServer start:&error]) {
        [NSException raise:NSInternalInconsistencyException format:@"Imposible to start HTTP Server. Error: %@", error];
    }
    if (![self.httpsServer start:&error]) {
        [NSException raise:NSInternalInconsistencyException format:@"Imposible to start HTTPS Server. Error: %@", error];
    }
}

-(void) addStubbedRequest:(LSStubRequest *)request {
    [self.mutableRequests addObject:request];
}

-(void) clearStubs {
    [self.mutableRequests removeAllObjects];
}

#pragma mark - Private
-(void) loadAdapters {
    [self loadASIHTTPRequestAdapater];
}

static LSNocilla *instance = nil;
static LSMethodSwizzler *swizzler = nil;

-(void) loadASIHTTPRequestAdapater {
    instance = self;
    swizzler = [[LSMethodSwizzler alloc] init];

    Class asiHttpRequestKlass = NSClassFromString(@"ASIHTTPRequest");
    Class selfClass = [self class];

    [swizzler swizzleInstanceMethod:@selector(startSynchronous)
                                inClass:asiHttpRequestKlass
                     withInstanceMethod:@selector(newStartSynchronous)
                                inClass:selfClass];

}

-(void) newStartSynchronous {
    /*
     [request setProxyHost:@"localhost"];
     [request setProxyPort:12345];
     */
    [self performSelector:@selector(setProxyHost:) withObject:@"localhost"];
    [self performSelector:@selector(setProxyPort:) withObject:(__bridge id)((void*)12345)];
    [swizzler deswizzle];
    [self performSelector:@selector(startSynchronous)]; // calling the old method
}

@end
