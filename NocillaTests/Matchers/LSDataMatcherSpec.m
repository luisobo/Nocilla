#import "Kiwi.h"
#import "LSDataMatcher.h"

SPEC_BEGIN(LSDataMatcherSpec)

__block LSDataMatcher *matcher = nil;
__block NSData *data = nil;

beforeEach(^{
    const char bytes[] = { 0xF1, 0x00, 0xFF };
    data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    matcher = [[LSDataMatcher alloc] initWithData:data];
});

context(@"when both data are equal", ^{
    it(@"matches", ^{
        [[theValue([matcher matchesData:[data copy]]) should] beYes];
    });
});

context(@"when both data are different", ^{
    it(@"does not match", ^{
        const char other_bytes[] = { 0xA1, 0x00, 0xAF };
        NSData *other_data = [NSData dataWithBytes:other_bytes length:sizeof(other_bytes)];

        [[theValue([matcher matchesData:other_data]) should] beNo];
    });
});

describe(@"isEqual:", ^{
    it(@"is equal to another data matcher with the same data", ^{
        LSDataMatcher *matcherA = [[LSDataMatcher alloc] initWithData:[@"same" dataUsingEncoding:NSUTF8StringEncoding]];
        LSDataMatcher *matcherB = [[LSDataMatcher alloc] initWithData:[@"same" dataUsingEncoding:NSUTF8StringEncoding]];

        [[matcherA should] equal:matcherB];
    });

    it(@"is not equal to another data matcher with a different data", ^{
        LSDataMatcher *matcherA = [[LSDataMatcher alloc] initWithData:[@"omg" dataUsingEncoding:NSUTF8StringEncoding]];
        LSDataMatcher *matcherB = [[LSDataMatcher alloc] initWithData:[@"different" dataUsingEncoding:NSUTF8StringEncoding]];

        [[matcherA shouldNot] equal:matcherB];
    });
});

SPEC_END
