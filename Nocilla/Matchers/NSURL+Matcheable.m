//
//  NSURL+Matcheable.m
//  Nocilla
//
//  Created by Nick Lockwood on 16/01/2017.
//  Copyright © 2017 Luis Solano Bonet. All rights reserved.
//

#import "NSURL+Matcheable.h"
#import "LSURLMatcher.h"

@implementation NSURL (Matcheable)

- (LSMatcher *)matcher {
    return [[LSURLMatcher alloc] initWithURL:self];
}

@end
