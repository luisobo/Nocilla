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

SPEC_END
