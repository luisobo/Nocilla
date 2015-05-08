#import <Foundation/Foundation.h>

@interface LSMatcher : NSObject

- (BOOL)matchesString:(NSString *)string;

- (BOOL)matches:(NSData *)data;

@end
