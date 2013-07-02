#import <Foundation/Foundation.h>
#import "NSString+Matcheable.h"
#import "NSString+Matcheable.h"
#import "NSRegularExpression+Matcheable.h"

@class LSStubRequestDSL;
@class LSStubResponseDSL;
@class LSStubRequest;

@protocol LSHTTPBody;

typedef LSStubRequestDSL *(^WithHeaderMethod)(NSString *, NSString *);
typedef LSStubRequestDSL *(^WithHeadersMethod)(NSDictionary *);
typedef LSStubRequestDSL *(^AndBodyMethod)(id<LSHTTPBody>);
typedef LSStubResponseDSL *(^AndReturnMethod)(NSInteger);
typedef LSStubResponseDSL *(^AndReturnRawResponseMethod)(NSData *rawResponseData);
typedef void (^AndFailWithErrorMethod)(NSError *error);

@interface LSStubRequestDSL : NSObject
- (id)initWithRequest:(LSStubRequest *)request;
- (WithHeaderMethod)withHeader;
- (WithHeadersMethod)withHeaders;
- (AndBodyMethod)withBody;
- (AndReturnMethod)andReturn;
- (AndReturnRawResponseMethod)andReturnRawResponse;
- (AndFailWithErrorMethod)andFailWithError;
@end

#ifdef __cplusplus
extern "C" {
#endif
    
LSStubRequestDSL * stubRequest(NSString *method, id<LSMatcheable> url);
    
#ifdef __cplusplus
}
#endif
