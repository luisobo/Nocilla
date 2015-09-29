#import "Kiwi.h"
#import "LSStringMatcher.h"

SPEC_BEGIN(LSStringMatcherSpec)

__block LSStringMatcher *matcher = nil;
beforeEach(^{
    matcher = [[LSStringMatcher alloc] initWithString:@"foo"];
});

context(@"when both strings are equal", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"foo"]) should] beYes];
    });
});

context(@"when both strings are different", ^{
    it(@"does not match", ^{
        [[theValue([matcher matches:@"bar"]) should] beNo];
    });
});

describe(@"isEqual:", ^{
    it(@"is equal to another string matcher with the same string", ^{
        LSStringMatcher *matcherA = [[LSStringMatcher alloc] initWithString:@"same"];
        LSStringMatcher *matcherB = [[LSStringMatcher alloc] initWithString:@"same"];

        [[matcherA should] equal:matcherB];
    });

    it(@"is not equal to another string matcher with a different string", ^{
        LSStringMatcher *matcherA = [[LSStringMatcher alloc] initWithString:@"omg"];
        LSStringMatcher *matcherB = [[LSStringMatcher alloc] initWithString:@"different"];

        [[matcherA shouldNot] equal:matcherB];
    });
});

SPEC_END