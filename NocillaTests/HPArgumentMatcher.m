//
//  HPErrorMatcher.m
//  Nocilla
//
//  Created by Hepeng Zhang on 2/28/15.
//  Copyright (c) 2015 Luis Solano Bonet. All rights reserved.
//

#import "HPArgumentMatcher.h"

@implementation HPArgumentMatcher

+ (instancetype)matcherWithBlock:(HPArgumentMatcherBlock)block
{
    HPArgumentMatcher* matcher = [[HPArgumentMatcher alloc] init];
    matcher.matchBlock = block;
    return matcher;
}

- (BOOL)matches:(id)object
{
    if (!self.matchBlock) {
        return NO;
    }
    return self.matchBlock(object);
}

@end
