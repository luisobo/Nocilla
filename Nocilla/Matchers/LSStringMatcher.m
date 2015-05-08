#import "LSStringMatcher.h"

@interface LSStringMatcher ()

@property (nonatomic, copy) NSString *string;

@end

@implementation LSStringMatcher

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = string;
    }
    return self;
}

- (BOOL)matches:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self.string isEqualToString:string];
}

@end
