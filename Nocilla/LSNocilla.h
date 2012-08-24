#import <Foundation/Foundation.h>
#import "Nocilla.h"

@class LSStubRequest;

extern NSString * const kLSUnexpectedRequest;

@interface LSNocilla : NSObject
+(LSNocilla *) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *stubbedRequests;
-(void) start;
-(void) addStubbedRequest:(LSStubRequest *)request;
-(void) clearStubs;
@end
