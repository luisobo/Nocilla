//
//  LSStubRequest+NSURLRequestMatcher.h
//  Nocilla
//
//  Created by Luis Solano Bonet on 26/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "LSStubRequest.h"

@interface LSStubRequest (NSURLRequestMatcher)
-(BOOL) matchesNSURLRequest:(NSURLRequest *)request;
@end
