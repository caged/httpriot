//
//  HRUtilitiesTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 7/22/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HTTPRiotTestHelper.h"
#import <HTTPRiot/HRBase64.h>

@interface HRUtilitiesTest : GHTestCase {} @end

@implementation HRUtilitiesTest
- (void)testShouldProperlyEncodeWithBase64 {
    NSData *data = [@"encytemedia@gmail.com:foobar" dataUsingEncoding:NSUTF8StringEncoding];
    GHAssertEqualStrings([HRBase64 encode:data], @"ZW5jeXRlbWVkaWFAZ21haWwuY29tOmZvb2Jhcg==", nil);
}
@end
