#import "LSHTTPRequestDiff.h"


@interface LSHTTPRequestDiff ()
@property (nonatomic, strong) id<LSHTTPRequest>oneRequest;
@property (nonatomic, strong) id<LSHTTPRequest>anotherRequest;

@end
@implementation LSHTTPRequestDiff
- (id)initWithRequest:(id<LSHTTPRequest>)oneRequest andRequest:(id<LSHTTPRequest>)anotherRequest {
    self = [super init];
    if (self) {
        _oneRequest = oneRequest;
        _anotherRequest = anotherRequest;
    }
    return self;
}

- (BOOL)isEmpty {
    if (![self.oneRequest.method isEqualToString:self.anotherRequest.method] ||
        ![self.oneRequest.url isEqual:self.anotherRequest.url] ||
        ![self.oneRequest.headers isEqual:self.anotherRequest.headers] ||
        ((self.oneRequest.body) && (![self.oneRequest.body isEqual:self.anotherRequest.body]))) {
        return NO;
    }
    return YES;

}

- (NSString *)description {
    if (![self.oneRequest.method isEqualToString:self.anotherRequest.method]) {
        return [NSString stringWithFormat:@"- Method: %@\n+ Method: %@\n", self.oneRequest.method, self.anotherRequest.method];
    } else if (![self.oneRequest.url isEqual:self.anotherRequest.url]) {
        return [NSString stringWithFormat:@"- URL: %@\n+ URL: %@\n", [self.oneRequest.url absoluteString], [self.anotherRequest.url absoluteString]];
    } else if(![self.oneRequest.headers isEqual:self.anotherRequest.headers]) {
        return [NSString stringWithFormat:@"Headers:\n-\t\"%@\": \"%@\"", @"Content-Type", @"application/json"];
    } else if(((self.oneRequest.body) && (![self.oneRequest.body isEqual:self.anotherRequest.body]))) {
        NSString *oneBody = [[NSString alloc] initWithData:self.oneRequest.body encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"- Body: \"%@\"", oneBody];
    }
    return @"";
}
@end
