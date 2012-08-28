#import "LSHTTPRequestDiff.h"


@interface LSHTTPRequestDiff ()
@property (nonatomic, strong) id<LSHTTPRequest>oneRequest;
@property (nonatomic, strong) id<LSHTTPRequest>anotherRequest;

- (BOOL)isMethodDifferent;
- (BOOL)isUrlDifferent;
- (BOOL)areHeadersDifferent;
- (BOOL)isBodyDifferent;
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
    if ([self isMethodDifferent] ||
        [self isUrlDifferent] ||
        [self areHeadersDifferent] ||
        [self isBodyDifferent]) {
        return NO;
    }
    return YES;

}

- (NSString *)description {
    if ([self isMethodDifferent]) {
        return [NSString stringWithFormat:@"- Method: %@\n+ Method: %@\n", self.oneRequest.method, self.anotherRequest.method];
    } else if ([self isUrlDifferent]) {
        return [NSString stringWithFormat:@"- URL: %@\n+ URL: %@\n", [self.oneRequest.url absoluteString], [self.anotherRequest.url absoluteString]];
    } else if([self areHeadersDifferent]) {
        return [NSString stringWithFormat:@"Headers:\n-\t\"%@\": \"%@\"", @"Content-Type", @"application/json"];
    } else if([self isBodyDifferent]) {
        NSString *oneBody = [[NSString alloc] initWithData:self.oneRequest.body encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"- Body: \"%@\"", oneBody];
    }
    return @"";
}

#pragma mark - Private Methods
- (BOOL)isMethodDifferent {
    return ![self.oneRequest.method isEqualToString:self.anotherRequest.method];
}

- (BOOL)isUrlDifferent {
    return ![self.oneRequest.url isEqual:self.anotherRequest.url];
}

- (BOOL)areHeadersDifferent {
    return ![self.oneRequest.headers isEqual:self.anotherRequest.headers];
}

- (BOOL)isBodyDifferent {
    return ((self.oneRequest.body) && (![self.oneRequest.body isEqual:self.anotherRequest.body]));
}
@end
