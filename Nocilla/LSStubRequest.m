#import "LSStubRequest.h"

@interface LSStubRequest ()
@property (nonatomic, assign, readwrite) NSString *method;
@property (nonatomic, strong) NSURL *urlObject;
@property (nonatomic, strong, readwrite) NSDictionary *mutableHeaders;
@property (nonatomic, strong, readwrite) NSString *body;
@property (nonatomic, strong, readwrite) LSStubResponse *response;
@end
@implementation LSStubRequest
@synthesize method = _method;
@synthesize mutableHeaders = _mutableHeaders;
@synthesize body = _body;
@synthesize urlObject = _urlObject;
@synthesize response = _response;

- (id)initWithMethod:(NSString *)method url:(NSString *)url {
    self = [super init];
    if (self) {
        self.method = method;
        self.urlObject = [NSURL URLWithString:url];
        self.mutableHeaders = [NSMutableDictionary dictionary];
        self.body = @"";
    }
    return self;
}

- (NSDictionary *) headers {
    return [NSDictionary dictionaryWithDictionary:self.mutableHeaders];;
}

- (NSString *)url {
    return [self.urlObject absoluteString];
}

- (WithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.mutableHeaders setValue:value forKey:header];
        return self;
    };
}

- (AndBodyMethod)andBody {
    return ^(NSString *body) {
        self.body = body;
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
@end

LSStubRequest * stubRequest(NSString *method, NSString *url) {
    LSStubRequest *request = [[LSStubRequest alloc] initWithMethod:method url:url];
    [[LSNocilla sharedInstace] addStubbedRequest:request];
    return request;
}


