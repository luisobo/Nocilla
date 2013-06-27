#import "Kiwi.h"
#import "LSRegexMatcher.h"
#import "NSString+Nocilla.h"

SPEC_BEGIN(LSRegexMatcherSpec)

__block LSRegexMatcher *matcher = nil;
beforeEach(^{
    matcher = [[LSRegexMatcher alloc] initWithRegex:@"Fo+".regex];
});

context(@"when the string matches the regex", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"Fo"]) should] beYes];
        [[theValue([matcher matches:@"Foo"]) should] beYes];
        [[theValue([matcher matches:@"Foooooo"]) should] beYes];
    });
});

context(@"when string does not match", ^{
    it(@"does not match", ^{
        [[theValue([matcher matches:@"fo"]) should] beNo];
        [[theValue([matcher matches:@"F"]) should] beNo];
        [[theValue([matcher matches:@"bar"]) should] beNo];
    });
});

SPEC_END