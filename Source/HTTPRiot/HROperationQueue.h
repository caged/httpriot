//
//  HROperationQueue.h
//  HTTPRiot
//
//  Created by Justin Palmer on 7/2/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HROperationQueue : NSOperationQueue {

}
+ (HROperationQueue *)sharedOperationQueue;
@end
