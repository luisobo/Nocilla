//
//  HPErrorMatcher.h
//  Nocilla
//
//  Created by Hepeng Zhang on 2/28/15.
//  Copyright (c) 2015 Luis Solano Bonet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Kiwi/KWGenericMatcher.h>

typedef BOOL (^HPArgumentMatcherBlock)(id subject);

@interface HPArgumentMatcher : NSObject <KWGenericMatching>

@property (nonatomic, copy) HPArgumentMatcherBlock matchBlock;

+ (instancetype) matcherWithBlock:(HPArgumentMatcherBlock)block;

@end
