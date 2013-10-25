#import "Kiwi.h"
#import "LSStubResponse.h"
#import "LSStubResponseDSL.h"

SPEC_BEGIN(LSStubResponseDSLSpec)

describe(@"#withBodyFile:", ^{
    
    __block LSStubResponseDSL *responseDSL;
    
    beforeEach(^{
        responseDSL = [[LSStubResponseDSL alloc] initWithResponse:[LSStubResponse new]];
    });
    
    context(@"when the file is not found", ^{
        it(@"raise an exception of file not found", ^{
            [[theBlock(^{
                responseDSL.withBodyFile(@"not-found.json");
            }) should] raise];
        });
    });
    
    context(@"when the json exists", ^{
        
        __block NSString *content;
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass: [self class]];
            NSString *jsonPath = [[bundle resourcePath] stringByAppendingPathComponent:@"exist.json"];
            
            content = @"{\"json\":\"it exists\"}";
            NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
            [[NSFileManager defaultManager] createFileAtPath:jsonPath
                                                    contents:fileContents
                                                  attributes:nil];
        });
        
        it(@"changes self.response.body to file content", ^{
            responseDSL.withBodyFile(@"exist.json");
            
            LSStubResponse *response = [responseDSL valueForKey:@"response"];
            NSData *data = response.body;
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[responseString should] equal:content];
        });
    });
});


SPEC_END