#import "LSStubRequest.h"
#import "LSMatcher.h"
#import "NSString+Matcheable.h"

@interface LSStubRequest ()
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) LSMatcher *urlMatcher;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableHeaders;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableCookies;

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
	if ([header isEqualToString:@"Cookie"]) {
		
		[self processCookieString:value block:^BOOL(NSString *header, NSString *value) {
			[self setCookie:header value:value];
			return YES;
		}];
	} else {
		[self.mutableHeaders setValue:value forKey:header];
	}
}

- (NSDictionary *)headers {
    return [NSDictionary dictionaryWithDictionary:self.mutableHeaders];;
}

- (void)setCookie:(NSString *)cookieName value:(NSString *)value {
	[self.mutableCookies setValue:value forKey:cookieName];
}

- (NSDictionary *)cookies {
	return [NSDictionary dictionaryWithDictionary:self.mutableCookies];;
}



- (NSString *)description {
    return [NSString stringWithFormat:@"StubRequest:\nMethod: %@\nURL: %@\nHeaders: %@\nCookies: %@\nBody: %@\nResponse: %@",
            self.method,
            self.urlMatcher,
            self.headers,
			self.cookies,
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
		&& [self matchesCookies:request]
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

-(BOOL) processCookieString:(NSString*)headerValue block:(BOOL (^)(NSString *header, NSString *value))block
{
	NSArray *cookieStrings = [headerValue componentsSeparatedByString:@"; "];

	for (NSString *cookieString in cookieStrings) {
		NSRange range = [cookieString rangeOfString:@"="];
		if (range.location != NSNotFound) {
			
			NSString *name = [cookieString substringToIndex:range.location];
			NSString *value = [cookieString substringFromIndex:range.location];
			
			if (! block(name, value)) {
				return NO;
			}
		}
		
	}
}

-(BOOL)matchesHeaders:(id<LSHTTPRequest>)request {
    for (NSString *header in self.headers) {
		if ([header isEqualToString:@"Cookie"]) {
			// should never happen
			return NO;
		}
		
        if (![[request.headers objectForKey:header] isEqualToString:[self.headers objectForKey:header]]) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)matchesCookie:(NSString*)cookieName value:(NSString*)value
{
	if (![value isEqualToString:[self.cookies objectForKey:cookieName]]) {
		return NO;
	}
	return YES;
}


-(BOOL)matchesCookies:(id<LSHTTPRequest>)request {
	for (NSString *cookie in self.cookies) {
		
		if (![self matchesCookie:cookie value:[request.cookies objectForKey:cookie]]) {
			return NO;
		}
	}
	return YES;
}

-(BOOL)matchesBody:(id<LSHTTPRequest>)request {
    NSData *reqBody = request.body;
    if (!self.body || [self.body matchesData:reqBody]) {
        return YES;
    }
    return NO;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[LSStubRequest class]]) {
        return NO;
    }

    return [self isEqualToStubRequest:object];
}

- (BOOL)isEqualToStubRequest:(LSStubRequest *)stubRequest {
    if (!stubRequest) {
        return NO;
    }

    BOOL methodEqual = [self.method isEqualToString:stubRequest.method];
    BOOL urlMatcherEqual = [self.urlMatcher isEqual:stubRequest.urlMatcher];
    BOOL headersEqual = [self.headers isEqual:stubRequest.headers];
    BOOL bodyEqual = (self.body == nil && stubRequest.body == nil) || [self.body isEqual:stubRequest.body];

    return methodEqual && urlMatcherEqual && headersEqual && bodyEqual;
}

- (NSUInteger)hash {
    return self.method.hash ^ self.urlMatcher.hash ^ self.headers.hash ^ self.body.hash;
}

@end


