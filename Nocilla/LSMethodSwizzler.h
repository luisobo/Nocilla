#import <Foundation/Foundation.h>

@interface LSMethodSwizzler : NSObject

- (void)swizzleClassMethod:(SEL)victimSelector inClass:(Class)victim withClassMethod:(SEL)attackerSelector inClass:(Class)attacker;
- (void)swizzleInstanceMethod:(SEL)victimSelector inClass:(Class)victim withInstanceMethod:(SEL)attackerSelector inClass:(Class)attacker;
- (void)deswizzle;

@end