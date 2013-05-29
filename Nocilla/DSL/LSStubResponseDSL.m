#import "LSStubResponseDSL.h"
#import "LSStubResponse.h"

@interface LSStubResponseDSL ()
@property (nonatomic, strong) LSStubResponse *response;
@end

@implementation LSStubResponseDSL
- (id)initWithResponse:(LSStubResponse *)response {
    self = [super init];
    if (self) {
        _response = response;
    }
    return self;
}
- (ResponseWithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.response setHeader:header value:value];
        return self;
    };
}

- (ResponseWithHeadersMethod)withHeaders; {
    return ^(NSDictionary *headers) {
        for (NSString *header in headers) {
            NSString *value = [headers objectForKey:header];
            [self.response setHeader:header value:value];
        }
        return self;
    };
}

- (ResponseWithBodyMethod)withBody {
    return ^(NSString *body) {
        self.response.body = [body dataUsingEncoding:NSUTF8StringEncoding];
        return self;
    };
}

- (ResponseWithJSONMethod)withJSON {
    return ^(NSDictionary *json) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];

        if (error) {
            [[NSException exceptionWithName:@"JSON Fixture Error" reason:@"Failed to make fixture JSON" userInfo:error.userInfo] raise];
        }

        [self.response setHeader:@"Content-Type" value:@"application/json"];
        self.response.body = jsonData;
        return self;
    };
}
@end
