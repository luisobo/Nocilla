
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
@property (nonatomic, strong, readwrite) NSData *body;
@property (nonatomic, strong) NSDictionary *mutableHeaders;
@property (nonatomic, assign) UInt64 offset;
@property (nonatomic, assign, getter = isDone) BOOL done;
@end

@implementation LSStubResponse

#pragma mark - DSL Methods
- (ResponseWithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.mutableHeaders setValue:value forKey:header];
        return self;
    };
}

- (ResponseWithBodyMethod)withBody {
    return ^(NSString *body) {
        self.body = [body dataUsingEncoding:NSUTF8StringEncoding];
        return self;
    };
}

#pragma Initializers
- (id) initDefaultResponse {
    self = [super init];
    if (self) {
        self.statusCode = 200;
        self.mutableHeaders = [NSMutableDictionary dictionary];
        self.body = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

-(id) initWithStatusCode:(NSInteger)statusCode {
    self = [super init];
    if (self) {
        self.statusCode = statusCode;
        self.mutableHeaders = [NSMutableDictionary dictionary];
        self.body = [@"" dataUsingEncoding:NSUTF8StringEncoding];
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
