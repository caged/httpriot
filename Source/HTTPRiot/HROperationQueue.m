//
//  HROperationQueue.m
//  HTTPRiot
//
//  Created by Justin Palmer on 7/2/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HROperationQueue.h"


@implementation HROperationQueue
static HROperationQueue *sharedHROperationQueue = nil;
- (id)init {
   if(self = [super init]) {
       [self setMaxConcurrentOperationCount:3];
   }
   
   return self;
}

+ (HROperationQueue *)sharedOperationQueue {
    @synchronized(self) {
        if (sharedHROperationQueue == nil) {
            [[self alloc] init];
        }
    }
    return sharedHROperationQueue;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedHROperationQueue == nil) {
            sharedHROperationQueue = [super allocWithZone:zone];
            return sharedHROperationQueue;
        }
    }
    return nil; 
}
 
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
 
- (id)retain {
    return self;
}
 
- (unsigned)retainCount {
    return NSUIntegerMax;
}
 
- (void)release {}
 
- (id)autorelease {
    return self;
}
@end
