#import <Foundation/Foundation.h>
#import "LSBlockResponse.h"
#import "LSHTTPResponse.h"

@protocol LSHTTPBody;

@interface LSStubResponse : NSObject<LSHTTPResponse>

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong) NSData *body;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) LSBlockResponse blockResponse;

@property (nonatomic, assign, readonly) BOOL shouldFail;
@property (nonatomic, strong, readonly) NSError *error;

- (id)initWithError:(NSError *)error;
- (id)initWithStatusCode:(NSInteger)statusCode;
- (id)initWithRawResponse:(NSData *)rawResponseData;
- (id)initWithBlock:(LSBlockResponse)block;
- (id)initDefaultResponse;
- (void)setHeader:(NSString *)header value:(NSString *)value;
@end
