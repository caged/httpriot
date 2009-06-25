//
//  NSObject+InvocationUtils.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/25/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (InvocationUtils)
- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)obj1 withObject:(id)obj2;
- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)obj1 withObject:(id)obj2 withObject:(id)obj3;
@end
