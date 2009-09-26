//
//  HROperationQueue.m
//  HTTPRiot
//
//  Created by Justin Palmer on 7/2/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HROperationQueue.h"
#import "HRGlobal.h"

static HROperationQueue *sharedHROperationQueue = nil;


@implementation HROperationQueue
+ (HROperationQueue *)sharedOperationQueue {
    @synchronized(self) {
        if (sharedHROperationQueue == nil) {
                sharedHROperationQueue = [[HROperationQueue alloc] init];
                sharedHROperationQueue.maxConcurrentOperationCount = 3;
        }
    }

    return sharedHROperationQueue;
}
@end
