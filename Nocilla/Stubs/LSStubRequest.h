#import <Foundation/Foundation.h>
#import "LSStubResponse.h"
#import "LSHTTPRequest.h"

@class LSURLMatcher;
@class LSStubRequest;
@class LSStubResponse;

@interface LSStubRequest : NSObject
@property (nonatomic, assign, readonly) NSString *method;
@property (nonatomic, strong, readonly) LSURLMatcher *urlMatcher;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readwrite) NSData *body;

@property (nonatomic, strong) LSStubResponse *response;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;
- (instancetype)initWithMethod:(NSString *)method urlMatcher:(LSURLMatcher *)urlMatcher;

- (void)setHeader:(NSString *)header value:(NSString *)value;

- (BOOL)matchesRequest:(id<LSHTTPRequest>)request;
@end
