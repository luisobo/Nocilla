#import "LSStubRequest.h"
#import "LSMatcher.h"
#import "NSString+Matcheable.h"

@interface LSStubRequest ()
@property (nonatomic, assign, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) LSMatcher *urlMatcher;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableHeaders;

-(BOOL)matchesMethod:(id<LSHTTPRequest>)request;
-(BOOL)matchesURL:(id<LSHTTPRequest>)request;
-(BOOL)matchesHeaders:(id<LSHTTPRequest>)request;
-(BOOL)matchesBody:(id<LSHTTPRequest>)request;
@end

@implementation LSStubRequest

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url {
    return [self initWithMethod:method urlMatcher:[url matcher]];
}

- (instancetype)initWithMethod:(NSString *)method urlMatcher:(LSMatcher *)urlMatcher; {
    self = [super init];
    if (self) {
        self.method = method;
        self.urlMatcher = urlMatcher;
        self.mutableHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setHeader:(NSString *)header value:(NSString *)value {
    [self.mutableHeaders setValue:value forKey:header];
}

- (NSDictionary *)headers {
    return [NSDictionary dictionaryWithDictionary:self.mutableHeaders];;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"StubRequest:\nMethod: %@\nURL: %@\nHeaders: %@\nBody: %@\nResponse: %@",
            self.method,
            self.urlMatcher,
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
    return [self.urlMatcher matches:[request.url absoluteString]];
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


