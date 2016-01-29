#import <Foundation/Foundation.h>

@protocol LSHTTPBody;

typedef void (^LSBlockResponse)(NSDictionary * __autoreleasing *headers, NSInteger *status, id<LSHTTPBody> __autoreleasing *body);
