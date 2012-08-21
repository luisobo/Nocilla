#import <Foundation/Foundation.h>
#import "Nocilla.h"

@class LSStubRequest;

@interface LSNocilla : NSObject
+(LSNocilla *) sharedInstace;
@property (nonatomic, strong, readonly) NSArray *stubbedRequests;
-(void) start;
-(void) addStubbedRequest:(LSStubRequest *)request;
-(void) clearStubs;
@end
