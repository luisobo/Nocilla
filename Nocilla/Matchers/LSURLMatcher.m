#import "LSURLMatcher.h"

@interface LSURLMatcher ()
@property (nonatomic, copy) NSURL *url;
@end

@implementation LSURLMatcher

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (BOOL)matches:(NSString *)string;{
    return [self.url isEqual:[NSURL URLWithString:string]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<LSURLMatcher URL:\"%@\">", [self.url absoluteString]];
}
@end
