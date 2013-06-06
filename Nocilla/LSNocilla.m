#import "LSNocilla.h"
#import "LSNSURLHook.h"
#import "LSStubRequest.h"
#import "LSHTTPRequestDSLRepresentation.h"
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

- (LSStubResponse *)responseForRequest:(id<LSHTTPRequest>)actualRequest {
    NSArray* requests = [LSNocilla sharedInstance].stubbedRequests;

    for(LSStubRequest *someStubbedRequest in requests) {
        if ([someStubbedRequest matchesRequest:actualRequest]) {
            return someStubbedRequest.response;
        }
    }
    [NSException raise:@"NocillaUnexpectedRequest" format:@"An unexcepted HTTP request was fired.\n\nUse this snippet to stub the request:\n%@\n", [[[LSHTTPRequestDSLRepresentation alloc] initWithRequest:actualRequest] description]];

    return nil;
}

#pragma mark - Private
- (void)loadHooks {
    [self loadHook:[[LSNSURLHook alloc] init]];
    [self loadHook:[[LSASIHTTPRequestHook alloc] init]];
}

- (void)unloadHooks {
    for (LSHTTPClientHook *hook in self.hooks) {
        [hook unload];
    }
}

- (void)loadHook:(LSHTTPClientHook *)hook {
    [self.hooks addObject:hook];
    [hook load];
}

@end
