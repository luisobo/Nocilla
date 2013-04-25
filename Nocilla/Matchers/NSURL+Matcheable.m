#import "NSURL+Matcheable.h"
#import "LSURLMatcher.h"

@implementation NSURL (Matcheable)

- (LSMatcher *)matcher {
    return [[LSURLMatcher alloc] initWithURL:self];
}

@end
