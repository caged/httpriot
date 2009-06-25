//
//  NSObject+InvocationUtils.m
//  HTTPRiot
//
//  Created by Justin Palmer on 6/25/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "NSObject+InvocationUtils.h"


@implementation NSObject (InvocationUtils)
- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)obj1 withObject:(id)obj2 {
    NSLog(@"SEL:%@", NSStringFromSelector(selector));
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    
    if(signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&obj1 atIndex:2];
        [invocation setArgument:&obj2 atIndex:3];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];   
    }
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)obj1 withObject:(id)obj2 withObject:(id)obj3 {
    NSLog(@"SEL:%@", NSStringFromSelector(selector));
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    
    if(signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&obj1 atIndex:2];
        [invocation setArgument:&obj2 atIndex:3];
        [invocation setArgument:&obj3 atIndex:4];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];   
    }
}
@end
