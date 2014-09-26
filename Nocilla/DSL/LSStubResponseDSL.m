#import "LSStubResponseDSL.h"
#import "LSStubResponse.h"
#import "LSHTTPBody.h"

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
    return ^(id<LSHTTPBody> body) {
        self.response.body = [body data];
        return self;
    };
}

- (ResponseWithBodyFileMethod)withBodyFile {
    return ^(NSString *file) {
        NSString *path = [[[NSBundle bundleForClass: [self class]] resourcePath] stringByAppendingPathComponent:file];
        NSError *error;
        id <LSHTTPBody> content = (id <LSHTTPBody>)[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error != nil && error.code == 260) {
            [NSException raise:@"File not found." format:@"Ensure that %@ does exists at path %@. Make sure that your file is inside of the test bundle.", file,[[NSBundle bundleForClass: [self class]] resourcePath]];
        }
        self.response.body = [content data];
        return self;
    };
}
@end
