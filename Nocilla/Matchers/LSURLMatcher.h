#import <Foundation/Foundation.h>

@interface LSURLMatcher : NSObject

- (instancetype)initWithURL:(NSURL *)url;

- (BOOL)matches:(NSURL *)url;

@end
