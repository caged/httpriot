//
//  HTTPRiotTestHelper.h
//  HTTPRiot
//
//  Created by Justin Palmer on 2/11/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//


#import <HTTPRiot/HTTPRiot.h>

#if !TARGET_IPHONE_SIMULATOR
#import <GHUnit/GHUnit.h>
#else
#import "GHUnit.h"
#endif

@interface HRTestHelper : NSObject {
    
} 

- (id)returnedResults:(id)info;
@end

// Get the compiler to STFU when testing private methods
@interface HRRestModel (STFU)
+ (void)setAttributeValue:(id)attr forKey:(NSString *)key;
+ (NSMutableDictionary *)classAttributes;
+ (NSMutableDictionary *)mergedOptions:(NSDictionary *)options;
@end

#define HTTPRiotTestServer @"http://localhost:4567"

@interface HRTestPerson  : HRRestModel {} @end
@interface HRTestPerson2 : HRRestModel {} @end
@interface HRTestPerson3 : HRRestModel {} @end
@interface HRTestPerson4 : HRRestModel {} @end
@interface HRTestPerson5 : HRRestModel {} @end
@interface HRTestPerson6 : HRRestModel {} @end
