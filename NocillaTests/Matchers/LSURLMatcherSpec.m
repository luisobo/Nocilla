#import "Kiwi.h"
#import "LSURLMatcher.h"

SPEC_BEGIN(LSURLMatcherSpec)

__block LSURLMatcher *matcher = nil;
beforeEach(^{
    matcher = [[LSURLMatcher alloc] initWithString:@"http://example.com?foo=bar&bar=foo"];
});

context(@"when both strings are equal", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"http://example.com?foo=bar&bar=foo"]) should] beYes];
    });
});

context(@"when both strings are equivalent", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"http://example.com?bar=foo&foo=bar"]) should] beYes];
    });
});

context(@"when both strings are different", ^{
    it(@"does not match", ^{
        [[theValue([matcher matches:@"http://example.com?foo=bar&bar=baz"]) should] beNo];
    });
});

describe(@"isEqual:", ^{
    it(@"is equal to another string matcher with the same string", ^{
        LSURLMatcher *matcherA = [[LSURLMatcher alloc] initWithString:@"http://example.com"];
        LSURLMatcher *matcherB = [[LSURLMatcher alloc] initWithString:@"http://example.com"];

        [[matcherA should] equal:matcherB];
    });

    it(@"is not equal to another string matcher with a different string", ^{
        LSURLMatcher *matcherA = [[LSURLMatcher alloc] initWithString:@"http://example.com?foo=bar"];
        LSURLMatcher *matcherB = [[LSURLMatcher alloc] initWithString:@"http://example.com?bar=foo"];

        [[matcherA shouldNot] equal:matcherB];
    });

    it(@"is not equal to another string matcher with an equivalent string", ^{
        LSURLMatcher *matcherA = [[LSURLMatcher alloc] initWithString:@"http://example.com?foo=bar&bar=foo"];
        LSURLMatcher *matcherB = [[LSURLMatcher alloc] initWithString:@"http://example.com?bar=foo&foo=bar"];

        [[matcherA shouldNot] equal:matcherB];
    });
});

SPEC_END
