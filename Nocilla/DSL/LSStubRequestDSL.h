#import <Foundation/Foundation.h>
#import "NSString+Matcheable.h"
#import "NSURL+Matcheable.h"

@class LSStubRequestDSL;
@class LSStubResponseDSL;
@class LSStubRequest;

typedef LSStubRequestDSL *(^WithHeaderMethod)(NSString *, NSString *);
typedef LSStubRequestDSL *(^WithHeadersMethod)(NSDictionary *);
typedef LSStubRequestDSL *(^AndBodyMethod)(NSString *);
typedef LSStubResponseDSL *(^AndReturnMethod)(NSInteger);
typedef LSStubResponseDSL *(^AndReturnRawResponseMethod)(NSData *rawResponseData);

@interface LSStubRequestDSL : NSObject
- (id)initWithRequest:(LSStubRequest *)request;
- (WithHeaderMethod)withHeader;
- (WithHeadersMethod)withHeaders;
- (AndBodyMethod)withBody;
- (AndReturnMethod)andReturn;
- (AndReturnRawResponseMethod)andReturnRawResponse;
@end

#ifdef __cplusplus
extern "C" {
#endif
    
LSStubRequestDSL * stubRequest(NSString *method, id<LSMatcheable> url);
    
#ifdef __cplusplus
}
#endif
