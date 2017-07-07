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

@implementation LSNSURLSessionHook {
    IMP ls_protocolClassesImplementation; // Implementation of `-(nullable NSArray *)protocolClasses` for this class
    IMP ns_protocolClassesImplementation; // Implementation of `-(nullable NSArray *)protocolClasses` for `NSURLSessionConfiguration` or its underlying class
}

- (Class)sessionConfigurationClass
{
    Class retClass = NSClassFromString(@"__NSCFURLSessionConfiguration");
    return retClass ?: NSClassFromString(@"NSURLSessionConfiguration");
}

- (char const *)typeEncodingForSelector:(SEL)selector
{
    return method_getTypeEncoding((class_getInstanceMethod([self class], selector)));
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        SEL selector = @selector(protocolClasses);
        ns_protocolClassesImplementation = class_getMethodImplementation(self.sessionConfigurationClass, selector);
        ls_protocolClassesImplementation = class_getMethodImplementation([self class], selector);
    }

    return self;
}

- (void)load
{
    if (!ns_protocolClassesImplementation || !ls_protocolClassesImplementation)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
    }

    SEL selector              = @selector(protocolClasses);
    const char *type_encoding = [self typeEncodingForSelector:selector];

    //Swap the implementations
    class_replaceMethod(self.class, selector, ns_protocolClassesImplementation, type_encoding);
    class_replaceMethod(self.sessionConfigurationClass, selector, ls_protocolClassesImplementation, type_encoding);
}

- (void)unload
{
    SEL selector              = @selector(protocolClasses);
    const char *type_encoding = [self typeEncodingForSelector:selector];

    //Restore the implementations
    class_replaceMethod(self.class, selector, ls_protocolClassesImplementation, type_encoding);
    class_replaceMethod(self.sessionConfigurationClass, selector, ns_protocolClassesImplementation, type_encoding);
}

- (NSArray *)protocolClasses
{
    return @[[LSHTTPStubURLProtocol class]];
}

@end
