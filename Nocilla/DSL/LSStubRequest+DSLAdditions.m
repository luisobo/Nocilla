#import "LSStubRequest+DSLAdditions.h"

@implementation LSStubRequest (DSLAdditions)
- (NSString *)toDSL {
    NSMutableString *result = [NSMutableString stringWithFormat:@"stubRequest(@\"%@\", @\"%@\")", self.method, [self.url absoluteString]];
    if (self.headers.count) {
        [result appendString:@".\nwithHeaders(@{ "];
        NSMutableArray *headerElements = [NSMutableArray arrayWithCapacity:self.headers.count];
        
        NSArray *descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES]];
        NSArray * sortedHeaders = [[self.headers allKeys] sortedArrayUsingDescriptors:descriptors];

        for (NSString * header in sortedHeaders) {
            NSString *value = [self.headers objectForKey:header];
            [headerElements addObject:[NSString stringWithFormat:@"@\"%@\": @\"%@\"", header, value]];
        }
        [result appendString:[headerElements componentsJoinedByString:@", "]];
        [result appendString:@" })"];
    }
    return [NSString stringWithFormat:@"%@;", result];
}
@end
