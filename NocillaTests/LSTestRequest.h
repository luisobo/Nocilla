#import <Foundation/Foundation.h>

#import "LSHTTPRequest.h"

@interface LSTestRequest : NSObject <LSHTTPRequest>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, readonly) NSDictionary *headers;
@property (nonatomic, strong) NSData *body;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;
- (void)setHeader:(NSString *)header value:(NSString *)value;
@end
