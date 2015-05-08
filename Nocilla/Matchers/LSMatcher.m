#import "LSMatcher.h"

@implementation LSMatcher

- (BOOL)matchesString:(NSString *)string {
    return [self matches:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)matches:(NSData *)data {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"[LSMatcher matches:] is an abstract method" userInfo:nil];
}

@end
