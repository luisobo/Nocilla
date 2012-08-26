//
//  LSHTTPClientHook.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 24/08/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import "LSHTTPClientHook.h"

@implementation LSHTTPClientHook
-(void) load {
    [NSException raise:NSInternalInconsistencyException
                format:@"Method '%@' not implemented. Subclass '%@' and override it", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(void) unload {
    [NSException raise:NSInternalInconsistencyException
                format:@"Method '%@' not implemented. Subclass '%@' and override it", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}
@end
