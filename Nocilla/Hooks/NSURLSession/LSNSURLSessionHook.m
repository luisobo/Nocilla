//
//  LSNSURLSessionHook.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 08/01/14.
//  Copyright (c) 2014 Luis Solano Bonet. All rights reserved.
//

#import "LSNSURLSessionHook.h"
#import "LSHTTPStubURLProtocol.h"
#import <objc/runtime.h>

@interface LSNSURLSessionHook ()
@property(strong, nonatomic) Class urlProtocolClass;
@end

@implementation LSNSURLSessionHook

- (Class)urlProtocolClass
{
    if (!_urlProtocolClass) {
        Class baseClass = [LSHTTPStubURLProtocol class];
        NSString * className = NSStringFromClass(baseClass);
        
        NSString * subclassName = [NSString stringWithFormat:@"%@%d", className, arc4random()];
        Class subclass = NSClassFromString(subclassName);
        
        if (subclass == nil) {
            subclass = objc_allocateClassPair(baseClass, [subclassName UTF8String], 0);
            if (subclass != nil) {
                objc_registerClassPair(subclass);
                _urlProtocolClass = subclass;
            }
        }
    }
    return _urlProtocolClass;
}

- (void)load {
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)unload {
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {

    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    Class stubUrlProtocolClass = self.urlProtocolClass;
    [stubUrlProtocolClass registerNocilla:self.nocilla];
    return @[stubUrlProtocolClass];
}

@end
