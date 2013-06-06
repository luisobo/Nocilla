#import <Foundation/Foundation.h>
#import "Nocilla.h"
#import "LSHTTPRequest.h"

@class LSStubRequest;
@class LSStubResponse;

extern NSString * const LSUnexpectedRequest;

@interface LSNocilla : NSObject
+ (LSNocilla *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *stubbedRequests;
- (void)start;
- (void)stop;
- (void)addStubbedRequest:(LSStubRequest *)request;
- (void)clearStubs;

- (LSStubResponse *)responseForRequest:(id<LSHTTPRequest>)request;
@end
