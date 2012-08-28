#import "LSHTTPRequestDiff.h"


@interface LSHTTPRequestDiff ()
@property (nonatomic, strong) id<LSHTTPRequest>oneRequest;
@property (nonatomic, strong) id<LSHTTPRequest>anotherRequest;

- (BOOL)isMethodDifferent;
- (BOOL)isUrlDifferent;
- (BOOL)areHeadersDifferent;
- (BOOL)isBodyDifferent;

- (NSString *)methodDiff;
- (NSString *)urlDiff;
- (NSString *)headersDiff;
- (NSString *)bodyDiff;
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
        return [self methodDiff];
    } else if ([self isUrlDifferent]) {
        return [self urlDiff];
    } else if([self areHeadersDifferent]) {
        return [self headersDiff];
    } else if([self isBodyDifferent]) {
        return [self bodyDiff];
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
    return (((self.oneRequest.body) && (![self.oneRequest.body isEqual:self.anotherRequest.body])) ||
            ((self.anotherRequest.body) && (![self.anotherRequest.body isEqual:self.oneRequest.body])));
}

- (NSString *)methodDiff {
    return [NSString stringWithFormat:@"- Method: %@\n+ Method: %@\n", self.oneRequest.method, self.anotherRequest.method];
}
- (NSString *)urlDiff {
    return [NSString stringWithFormat:@"- URL: %@\n+ URL: %@\n", [self.oneRequest.url absoluteString], [self.anotherRequest.url absoluteString]];
}
- (NSString *)headersDiff {
    NSMutableString *result = [NSMutableString stringWithString:@"Headers:\n"];
    NSSet *headersInOneButNotInTheOther = [self.oneRequest.headers keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return ![self.anotherRequest.headers objectForKey:key];
    }];
    NSSet *headersInTheOtherButNotInOne = [self.anotherRequest.headers keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return ![self.oneRequest.headers objectForKey:key];
    }];
    for (NSString *header in headersInOneButNotInTheOther) {
        NSString *value = [self.oneRequest.headers objectForKey:header];
        [result appendFormat:@"-\t\"%@\": \"%@\"\n", header, value];
    }
    for (NSString *header in headersInTheOtherButNotInOne) {
        NSString *value = [self.anotherRequest.headers objectForKey:header];
        [result appendFormat:@"+\t\"%@\": \"%@\"\n", header, value];
    }
    return [NSString stringWithString:result];
}
- (NSString *)bodyDiff {
    NSMutableString *result = [NSMutableString string];
    NSString *oneBody = [[NSString alloc] initWithData:self.oneRequest.body encoding:NSUTF8StringEncoding];
    if (oneBody.length) {
        [result appendFormat:@"- Body: \"%@\"\n", oneBody];
    }
    NSString *anotherBody = [[NSString alloc] initWithData:self.anotherRequest.body encoding:NSUTF8StringEncoding];
    if (anotherBody.length) {
        [result appendFormat:@"+ Body: \"%@\"\n", anotherBody];
    }
    return [NSString stringWithString:result];
}
@end
