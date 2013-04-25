#import "LSTestRequest.h"

@interface LSTestRequest ()
@property  (nonatomic, strong) NSMutableDictionary *mutableHeaders;
@end

@implementation LSTestRequest

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url {
    self = [super init];
    if (self) {
        _method = method;
        _url = [NSURL URLWithString:url];
        _mutableHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setHeader:(NSString *)header value:(NSString *)value {
    self.mutableHeaders[header] = value;
}

- (NSDictionary *)headers {
    return [self.mutableHeaders copy];
}

@end
