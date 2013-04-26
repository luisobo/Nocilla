#import "NSString+Regex.h"

@implementation NSString (Regex)

- (NSRegularExpression *)regex {
    NSError *error = nil;
    NSRegularExpression *regex =  [[NSRegularExpression alloc] initWithPattern:self options:0 error:&error];
    if (error) {
        [NSException raise:NSInvalidArgumentException format:@"Invalid regex pattern: %@\nError: %@", self, error];
    }
    return regex;
}

@end
