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

			if (actualCount < expectedCount) {
				NSString *msg = [NSString stringWithFormat:@"The request to \"%@\" should be fired %d times but was fired %d times.\n",
								someStubbedRequest.urlMatcher.description, expectedCount, actualCount];
				NSException *exception = [NSException exceptionWithName:@"NocillaMissingRequest" reason:msg userInfo:nil];
				[exception raise];
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

			// check if the request was already sent to often
			if (someStubbedRequest.expectedCallCount != nil) {
				NSInteger actualCount = someStubbedRequest.actualCallCount;
				NSInteger expectedCount = someStubbedRequest.expectedCallCount.integerValue;
				if(actualCount > expectedCount) {
					NSString *msg = [NSString stringWithFormat:@"An unexpected HTTP request to \"%@\" was fired.\n"
																	   "You already stubbed this request but it should be fired %d times but was fired %d times.\n",
															   someStubbedRequest.urlMatcher.description, expectedCount, actualCount];
					[NSException raise:@"NocillaUnexpectedRequest" format:msg];
				}
			}

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
