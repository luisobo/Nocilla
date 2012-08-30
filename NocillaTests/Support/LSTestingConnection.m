#import "LSTestingConnection.h"
#import "HTTPDataResponse.h"
#import "HTTPResponse.h"
@implementation LSTestingConnection
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    return YES;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSObject<HTTPResponse> *response = [[HTTPDataResponse alloc] initWithData:[@"hola" dataUsingEncoding:NSUTF8StringEncoding]];
    
    return response;
}

@end
