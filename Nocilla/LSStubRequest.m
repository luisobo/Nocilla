#import "LSStubRequest.h"

@interface LSStubRequest ()
@property (nonatomic, assign, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableHeaders;
@property (nonatomic, strong, readwrite) LSStubResponse *response;
@end
@implementation LSStubRequest
- (id)initWithMethod:(NSString *)method url:(NSString *)url {
    self = [super init];
    if (self) {
        self.method = method;
        self.url = [NSURL URLWithString:url];
        self.mutableHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) setHeader:(NSString *)header value:(NSString *)value {
    [self.mutableHeaders setValue:value forKey:header];
}

- (NSDictionary *) headers {
    return [NSDictionary dictionaryWithDictionary:self.mutableHeaders];;
}

- (WithHeadersMethod)withHeaders {
    return ^(NSDictionary *headers) {
        [self.mutableHeaders addEntriesFromDictionary:headers];
        return self;
    };
}

- (WithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.mutableHeaders setValue:value forKey:header];
        return self;
    };
}

- (AndBodyMethod)withBody {
    return ^(NSString *body) {
        self.body = [body dataUsingEncoding:NSUTF8StringEncoding];
        return self;
    };
}

-(AndReturnMethod)andReturn {
    return ^(NSInteger statusCode) {
        self.response = [[LSStubResponse alloc] initWithStatusCode:statusCode];
        return self.response;
    };
}

- (NSString *) description {
    return [NSString stringWithFormat:@"StubRequest:\nMethod: %@\nURL: %@\nHeaders: %@\nBody: %@\nResponse: %@",
            self.method,
            self.url,
            self.headers,
            self.body,
            self.response];
}

- (LSStubResponse *)response {
    if (!_response) {
        _response = [[LSStubResponse alloc] initDefaultResponse];
    }
    return _response;
    
}

- (BOOL)matchesRequest:(id<LSHTTPRequest>)request {
    if ([self matchesMethod:request]
        && [self matchesURL:request]
        && [self matchesHeaders:request]
        && [self matchesBody:request]
        ) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesMethod:(id<LSHTTPRequest>)request {
    if (!self.method || [self.method isEqualToString:request.method]) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesURL:(id<LSHTTPRequest>)request {
    NSString *a = [self.url absoluteString];
    NSString *b = [request.url absoluteString];
    if ([a isEqualToString:b]) {
        return YES;
    }
    return NO;
}

-(BOOL)matchesHeaders:(id<LSHTTPRequest>)request {
    for (NSString *header in self.headers) {
        if (![[request.headers objectForKey:header] isEqualToString:[self.headers objectForKey:header]]) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)matchesBody:(id<LSHTTPRequest>)request {
    NSData *selfBody = self.body;
    NSData *reqBody = request.body;
    if (!selfBody || [selfBody isEqualToData:reqBody]) {
        return YES;
    }
    return NO;
}
@end

LSStubRequest * stubRequest(NSString *method, NSString *url) {
    LSStubRequest *request = [[LSStubRequest alloc] initWithMethod:method url:url];
    [[LSNocilla sharedInstance] addStubbedRequest:request];
    return request;
}


