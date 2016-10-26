#import <Foundation/Foundation.h>
#import "NSString+Matcheable.h"
#import "NSRegularExpression+Matcheable.h"
#import "NSData+Matcheable.h"

@class LSStubRequestDSL;
@class LSStubResponseDSL;
@class LSStubRequest;

@protocol LSHTTPBody;

typedef LSStubRequestDSL * _Nonnull (^WithHeaderMethod)(NSString * _Nonnull, NSString * _Nullable);
typedef LSStubRequestDSL * _Nonnull (^WithHeadersMethod)(NSDictionary * _Nullable);
typedef LSStubRequestDSL * _Nonnull (^AndBodyMethod)(_Nullable id<LSMatcheable>);
typedef LSStubResponseDSL * _Nonnull (^AndReturnMethod)(NSInteger);
typedef LSStubResponseDSL * _Nonnull (^AndReturnRawResponseMethod)(NSData * _Nonnull rawResponseData);
typedef void (^AndFailWithErrorMethod)(NSError * _Nonnull error);

@interface LSStubRequestDSL : NSObject
- (id _Nonnull)initWithRequest:(LSStubRequest * _Nonnull)request;

@property (nonatomic, strong, readonly) _Nonnull WithHeaderMethod withHeader;
@property (nonatomic, strong, readonly) _Nonnull WithHeadersMethod withHeaders;
@property (nonatomic, strong, readonly) _Nonnull AndBodyMethod withBody;
@property (nonatomic, strong, readonly) _Nonnull AndReturnMethod andReturn;
@property (nonatomic, strong, readonly) _Nonnull AndReturnRawResponseMethod andReturnRawResponse;
@property (nonatomic, strong, readonly) _Nonnull AndFailWithErrorMethod andFailWithError;

@end

#ifdef __cplusplus
extern "C" {
#endif

LSStubRequestDSL * _Nonnull stubRequest(NSString * _Nonnull method, _Nonnull id<LSMatcheable> url);

#ifdef __cplusplus
}
#endif
