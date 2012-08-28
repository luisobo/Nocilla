#import <Foundation/Foundation.h>
#import "LSStubResponse.h"
#import "LSHTTPRequest.h"

@class LSStubRequest;
@class LSStubResponse;

typedef LSStubRequest *(^WithHeaderMethod)(NSString *, NSString *);
typedef LSStubRequest *(^WithHeadersMethod)(NSDictionary *);
typedef LSStubRequest *(^AndBodyMethod)(NSString *);
typedef LSStubResponse *(^AndReturnMethod)(NSInteger);

@interface LSStubRequest : NSObject<LSHTTPRequest>
- (WithHeaderMethod)withHeader;
- (WithHeadersMethod)withHeaders;
- (AndBodyMethod)withBody;
- (AndReturnMethod)andReturn;

@property (nonatomic, assign, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readwrite) NSData *body;

@property (nonatomic, strong, readonly) LSStubResponse *response;

- (id)initWithMethod:(NSString *)method url:(NSString *)url;
- (void) setHeader:(NSString *)header value:(NSString *)value;

- (BOOL)matchesRequest:(id<LSHTTPRequest>)request;
@end

LSStubRequest * stubRequest(NSString *method, NSString *url);
