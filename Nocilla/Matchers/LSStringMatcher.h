#import <Foundation/Foundation.h>

@interface LSStringMatcher : NSObject

- (instancetype)initWithString:(NSString *)string;

- (BOOL)matches:(NSString *)string;

@end
