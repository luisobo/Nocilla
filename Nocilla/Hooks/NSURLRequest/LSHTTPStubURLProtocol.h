#import <Foundation/Foundation.h>
#import "LSNocilla.h"

@interface LSHTTPStubURLProtocol : NSURLProtocol

+ (void)registerNocilla:(LSNocilla *)nocilla;
+ (Class)randomSubclass;

@end
