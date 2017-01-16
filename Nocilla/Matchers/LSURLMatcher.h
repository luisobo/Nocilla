//
//  LSURLMatcher.h
//  Nocilla
//
//  Created by Nick Lockwood on 16/01/2017.
//  Copyright © 2017 Luis Solano Bonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSMatcher.h"

@interface LSURLMatcher : LSMatcher

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithString:(NSString *)urlString;

@end
