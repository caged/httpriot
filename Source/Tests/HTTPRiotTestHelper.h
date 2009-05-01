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

// Get the compiler to STFU when testing private methods
@interface HTTPRiotRestModel (STFU)
+ (void)setAttributeValue:(id)attr forKey:(NSString *)key;
+ (NSMutableDictionary *)classAttributes;
+ (NSMutableDictionary *)mergedOptions:(NSDictionary *)options;
@end

#define HTTPRiotTestServer @"http://localhost:4567"

@interface HRTestPerson  : HTTPRiotRestModel {} @end
@interface HRTestPerson2 : HTTPRiotRestModel {} @end
@interface HRTestPerson3 : HTTPRiotRestModel {} @end
@interface HRTestPerson4 : HTTPRiotRestModel {} @end
@interface HRTestPerson5 : HTTPRiotRestModel {} @end
@interface HRTestPerson6 : HTTPRiotRestModel {} @end
