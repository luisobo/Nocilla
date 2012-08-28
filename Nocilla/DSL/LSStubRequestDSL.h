#import <Foundation/Foundation.h>
#import "LSStubRequest.h"
#import "LSStubResponse.h"

@class LSStubRequestDSL;
@class LSStubResponseDSL;

typedef LSStubRequestDSL *(^WithHeaderMethod)(NSString *, NSString *);
typedef LSStubRequestDSL *(^WithHeadersMethod)(NSDictionary *);
typedef LSStubRequestDSL *(^AndBodyMethod)(NSString *);
typedef LSStubResponseDSL *(^AndReturnMethod)(NSInteger);

@interface LSStubRequestDSL : NSObject
- (id)initWithRequest:(LSStubRequest *)request;
- (WithHeaderMethod)withHeader;
- (WithHeadersMethod)withHeaders;
- (AndBodyMethod)withBody;
- (AndReturnMethod)andReturn;
@end

LSStubRequestDSL * stubRequest(NSString *method, NSString *url);
