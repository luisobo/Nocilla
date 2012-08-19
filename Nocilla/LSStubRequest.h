#import <Foundation/Foundation.h>
#import "LSStubResponse.h"

@class LSStubRequest;
@class LSStubResponse;

typedef LSStubRequest *(^WithHeaderMethod)(NSString *, NSString *);
typedef LSStubRequest *(^AndBodyMethod)(NSString *);
typedef LSStubResponse *(^AndReturnMethod)(NSInteger);

@interface LSStubRequest : NSObject
- (WithHeaderMethod)withHeader;
- (AndBodyMethod)withBody;
- (AndReturnMethod)andReturn;

@property (nonatomic, assign, readonly) NSString *method;
@property (nonatomic, assign, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSString *body;

@property (nonatomic, strong, readonly) LSStubResponse *response;

- (id)initWithMethod:(NSString *)method url:(NSString *)url;
@end

LSStubRequest * stubRequest(NSString *method, NSString *url);
