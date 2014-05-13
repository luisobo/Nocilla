#import "LSNocilla.h"
#import "LSNSURLHook.h"
#import "LSStubRequest.h"
#import "LSHTTPRequestDSLRepresentation.h"
#import "LSASIHTTPRequestHook.h"
#import "LSNSURLSessionHook.h"
#import "LSASIHTTPRequestHook.h"

NSString * const LSUnexpectedRequest = @"Unexpected Request";

@interface LSNocilla ()
@property (nonatomic, strong) NSMutableArray *mutableRequests;
@property (nonatomic, strong) NSMutableArray *hooks;
@property (nonatomic, assign, getter = isStarted) BOOL started;

@property (nonatomic) BOOL testmode;

- (void)loadHooks;
- (void)unloadHooks;
@end

static LSNocilla *sharedInstace = nil;

@implementation LSNocilla

+ (LSNocilla *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

- (id)init {
    self = [super init];
    if (self) {
        _mutableRequests = [NSMutableArray array];
        _hooks = [NSMutableArray array];
        [self registerHook:[[LSNSURLHook alloc] init]];
        if (NSClassFromString(@"NSURLSession") != nil) {
            [self registerHook:[[LSNSURLSessionHook alloc] init]];
        }
        [self registerHook:[[LSASIHTTPRequestHook alloc] init]];
    }
    return self;
}

- (NSArray *)stubbedRequests {
    return [NSArray arrayWithArray:self.mutableRequests];
}

- (void)start {
    if (!self.isStarted){
        [self loadHooks];
        self.started = YES;
    }
}

- (void)stop {
    [self unloadHooks];
    [self clearStubs];
    self.started = NO;
}

- (void)addStubbedRequest:(LSStubRequest *)request {
    [self.mutableRequests addObject:request];
}

- (void)clearStubs {
    [self.mutableRequests removeAllObjects];
}

- (void)verifyCallCount {
	NSArray* requests = [LSNocilla sharedInstance].stubbedRequests;

	for(LSStubRequest *someStubbedRequest in requests) {
		if (someStubbedRequest.expectedCallCount != nil) {

			NSInteger actualCount = someStubbedRequest.actualCallCount;
			NSInteger expectedCount = someStubbedRequest.expectedCallCount.integerValue;

			// the exceptions need to be fired on an other thread than the main thread
			// cause otherwise they might be caught by other frameworks and won't get logged!
			NSException *exception;
			if (actualCount < expectedCount) {
				NSString *msg = [NSString stringWithFormat:@"The request should be fired %d times but was fired %d times.\n", expectedCount,
														   actualCount]                                                                      ;
				exception = [NSException exceptionWithName:@"NocillaMissingRequest" reason:msg userInfo:nil];
			} else if(actualCount > expectedCount) {
				NSString *msg = [NSString stringWithFormat:@"An unexpected HTTP request was fired.\n\nYou already stubbed this request but it was called %d times instead of expected %d times.\n", actualCount, expectedCount]                                                                      ;
				exception = [NSException exceptionWithName:@"NocillaUnexpectedRequest" reason:msg userInfo:nil];
			}
			// we need to raise the exception on the main thread when testing
			// otherwise the tests will crash cause we cannot catch and assert the exception...
			if (self.testmode) {
				[exception raise];
			} else {
				[exception performSelectorInBackground:@selector(raise) withObject:nil];
			}

		}
	}
}


- (LSStubResponse *)responseForRequest:(id<LSHTTPRequest>)actualRequest {
    NSArray* requests = [LSNocilla sharedInstance].stubbedRequests;

    for(LSStubRequest *someStubbedRequest in requests) {
        if ([someStubbedRequest matchesRequest:actualRequest]) {
            return someStubbedRequest.response;
        }
    }
    [NSException raise:@"NocillaUnexpectedRequest" format:@"An unexpected HTTP request was fired.\n\nUse this snippet to stub the request:\n%@\n", [[[LSHTTPRequestDSLRepresentation alloc] initWithRequest:actualRequest] description]];

    return nil;
}

- (void)countRequest:(id<LSHTTPRequest>)actualRequest {
	NSArray* requests = [LSNocilla sharedInstance].stubbedRequests;

	for(LSStubRequest *someStubbedRequest in requests) {
		if ([someStubbedRequest matchesRequest:actualRequest]) {
			someStubbedRequest.actualCallCount++;
			return;
		}
	}
}

- (void)registerHook:(LSHTTPClientHook *)hook {
    if (![self hookWasRegistered:hook]) {
        [[self hooks] addObject:hook];
    }
}
- (BOOL)hookWasRegistered:(LSHTTPClientHook *)aHook {
    for (LSHTTPClientHook *hook in self.hooks) {
        if ([hook isMemberOfClass: [aHook class]]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - Private

- (void)loadHooks {
    for (LSHTTPClientHook *hook in self.hooks) {
        [hook load];
    }
}

- (void)unloadHooks {
    for (LSHTTPClientHook *hook in self.hooks) {
        [hook unload];
    }
}
@end
