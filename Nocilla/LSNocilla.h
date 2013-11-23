#import <Foundation/Foundation.h>
#import "Nocilla.h"

@class LSStubRequest;
@class LSStubResponse;
@class LSHTTPClientHook;
@protocol LSHTTPRequest;

extern NSString * const LSUnexpectedRequest;

@interface LSNocilla : NSObject
+ (LSNocilla *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *stubbedRequests;
- (void)start;
- (void)stop;
- (void)addStubbedRequest:(LSStubRequest *)request;
- (void)removeStubbedRequest:(LSStubRequest *)request;
- (void)clearStubs;

- (void)registerHook:(LSHTTPClientHook *)hook;

- (LSStubResponse *)responseForRequest:(id<LSHTTPRequest>)request;
@end
