//
//  LSStubResponse.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LSStubResponse.h"

@interface LSStubResponse ()
@property (nonatomic, assign, readwrite) NSInteger statusCode;
@property (nonatomic, strong, readwrite) NSString *body;
@property (nonatomic, strong) NSDictionary *mutableHeaders;
@end

@implementation LSStubResponse
@synthesize statusCode  = _statusCode;
@synthesize body = _body;
@synthesize mutableHeaders = _mutableHeaders;
- (ResponseWithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.mutableHeaders setValue:value forKey:header];
        return self;
    };
}

- (ResponseWithBodyMethod)withBody {
    return ^(NSString *body) {
        self.body = body;
        return self;
    };
}

- (id) initWithStatusCode:(NSInteger)statusCode {
    self = [super init];
    if (self) {
        self.statusCode = statusCode;
        self.mutableHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSDictionary *)headers{
    return [NSDictionary dictionaryWithDictionary:self.mutableHeaders];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"StubRequest:\nStatus Code: %d\nHeaders: %@\nBody: %@",
            self.statusCode,
            self.mutableHeaders,
            self.body];
}
@end
