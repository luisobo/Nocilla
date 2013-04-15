#import <Foundation/Foundation.h>
#import "LSStubResponse.h"
#import "LSHTTPRequest.h"

@class LSStubRequest;
@class LSStubResponse;

@interface LSStubRequest : NSObject<LSHTTPRequest>
@property (nonatomic, assign, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readwrite) NSData *body;

@property (nonatomic, strong) LSStubResponse *response;

@property(nonatomic, strong) NSRegularExpression *urlRegex;

- (id)initWithMethod:(NSString *)method url:(NSString *)url;

- (id)initWithMethod:(NSString *)method urlRegex:(NSRegularExpression *)urlRegex;

- (void)setHeader:(NSString *)header value:(NSString *)value;

- (BOOL)matchesRequest:(id<LSHTTPRequest>)request;
@end
