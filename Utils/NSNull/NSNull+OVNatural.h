//
// Created by kazuma.ukyo on 12/27/12.
//  处理 服务器返回NSNull问题
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

// http://stackoverflow.com/questions/2060741/does-objective-c-use-short-circuit-evaluation

@interface NSNull (OVNatural)
- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
@end
