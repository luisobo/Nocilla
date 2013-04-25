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

SPEC_END