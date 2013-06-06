#import "LSStubRequest.h"
#import "LSMatcher.h"
#import "NSString+Matcheable.h"

static NSString * LSBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];

    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];

    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

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

- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password {
	NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    [self setHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@", LSBase64EncodedStringFromString(basicAuthCredentials)]];
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


