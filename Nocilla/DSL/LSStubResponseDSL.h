#import <Foundation/Foundation.h>

@class LSStubResponse;
@class LSStubResponseDSL;

typedef LSStubResponseDSL *(^ResponseWithBodyMethod)(NSString *);
typedef LSStubResponseDSL *(^ResponseWithDataMethod)(NSData *);
typedef LSStubResponseDSL *(^ResponseWithHeaderMethod)(NSString *, NSString *);
typedef LSStubResponseDSL *(^ResponseWithHeadersMethod)(NSDictionary *);

@interface LSStubResponseDSL : NSObject
- (id)initWithResponse:(LSStubResponse *)response;
- (ResponseWithHeaderMethod)withHeader;
- (ResponseWithHeadersMethod)withHeaders;
- (ResponseWithBodyMethod)withBody;
- (ResponseWithDataMethod)withData;
@end
