#import <Foundation/Foundation.h>
#import "Nocilla.h"

@class LSStubRequest;
@class LSStubRequestDSL;
@class LSStubResponse;
@class LSHTTPClientHook;
@protocol LSHTTPRequest;
@protocol LSMatcheable;

extern NSString * const LSUnexpectedRequest;

typedef LSStubRequestDSL *(^StubRequestMethod)(NSString *method, id<LSMatcheable> url);

@interface LSNocilla : NSObject
+ (LSNocilla *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *stubbedRequests;
@property (nonatomic, assign, readonly, getter = isStarted) BOOL started;
@property (nonatomic, strong, readonly) StubRequestMethod stubRequest;


- (void)start;
- (void)stop;
- (void)addStubbedRequest:(LSStubRequest *)request;
- (void)clearStubs;

- (void)registerHook:(LSHTTPClientHook *)hook;

- (LSStubResponse *)responseForRequest:(id<LSHTTPRequest>)request;

@end
