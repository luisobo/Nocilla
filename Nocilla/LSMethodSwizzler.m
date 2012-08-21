#import "LSMethodSwizzler.h"
#import <objc/runtime.h>

@interface LSMethodSwizzler ()

@property (nonatomic, assign) Method originalMethod;
@property (nonatomic, assign) Method swizzleMethod;


@end

@implementation LSMethodSwizzler

- (void)swizzleClassMethod:(SEL)victimSelector inClass:(Class)victim withClassMethod:(SEL)attackerSelector inClass:(Class)attacker {
       self.originalMethod = class_getClassMethod(victim, victimSelector);
       self.swizzleMethod = class_getClassMethod(attacker, attackerSelector);
       method_exchangeImplementations(self.originalMethod, self.swizzleMethod);
}


- (void)swizzleInstanceMethod:(SEL)victimSelector inClass:(Class)victim withInstanceMethod:(SEL)attackerSelector inClass:(Class)attacker {
    self.originalMethod = class_getInstanceMethod(victim, victimSelector);
    self.swizzleMethod = class_getInstanceMethod(attacker, attackerSelector);
    if (class_addMethod(victim, victimSelector, method_getImplementation(self.swizzleMethod), method_getTypeEncoding(self.swizzleMethod))) {
        class_replaceMethod(victim, attackerSelector, method_getImplementation(self.originalMethod), method_getTypeEncoding(self.originalMethod));
    } else {
        method_exchangeImplementations(self.originalMethod, self.swizzleMethod);
    }
}

- (void)deswizzle {
       method_exchangeImplementations(self.swizzleMethod, self.originalMethod);
       self.swizzleMethod = nil;
       self.originalMethod = nil;
}

@end