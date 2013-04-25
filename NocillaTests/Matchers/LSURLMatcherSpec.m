#import "Kiwi.h"
#import "LSURLMatcher.h"

SPEC_BEGIN(LSURLMatcherSpec)

__block LSURLMatcher *matcher = nil;
beforeEach(^{
    matcher = [[LSURLMatcher alloc] initWithURL:[NSURL URLWithString:@"http://www.github.com/luisobo/Nocilla"]];
});

context(@"when both urls are equal", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"http://www.github.com/luisobo/Nocilla"]) should] beYes];
    });
});

context(@"when both strings are different", ^{
    it(@"does not match", ^{
        [[theValue([matcher matches:@"http://www.github.com/luisobo/StateMachine"]) should] beNo];
    });
});

SPEC_END