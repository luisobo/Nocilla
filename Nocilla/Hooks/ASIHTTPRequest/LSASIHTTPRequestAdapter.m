#import "LSASIHTTPRequestAdapter.h"
#import "ASIHTTPRequest.h"

@interface LSASIHTTPRequestAdapter ()
@property (nonatomic, strong) ASIHTTPRequest *request;
@end

@implementation LSASIHTTPRequestAdapter

- (instancetype)initWithASIHTTPRequest:(ASIHTTPRequest *)request {
    self = [super init];
    if (self) {
        _request = request;
    }
    return self;
}

- (NSURL *)url {
    return self.request.url;
}

- (NSString *)method {
    return self.request.requestMethod;
}

- (NSDictionary *)headers {
    return self.request.requestHeaders;
}

- (NSData *)body {
    return self.request.postBody;
}

@end
