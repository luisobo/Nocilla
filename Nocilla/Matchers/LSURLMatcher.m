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

- (BOOL)matches:(NSURL *)url {
    return [self.url isEqual:url];
}

@end
