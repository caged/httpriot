//
//  NSStringURLTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 7/8/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HTTPRiotTestHelper.h"
#import "HTTPRiot/NSString+EscapingUtils.h"

@interface NSStringURLTest : GHTestCase {} @end

@implementation NSStringURLTest
- (void)testShouldEscapeQueryValues {
    GHAssertEqualStrings([@"foo bar" stringByPreparingForURL], @"foo%20bar", nil);
    GHAssertEqualStrings([@"foo+bar" stringByPreparingForURL], @"foo%2Bbar", nil);
    GHAssertEqualStrings([@"._-~" stringByPreparingForURL], @"._-~", nil);
    GHAssertEqualStrings([@"&=" stringByPreparingForURL], @"%26%3D", nil);
}
@end
