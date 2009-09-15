//
//  NSStringURLTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 7/8/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HTTPRiotTestHelper.h"
#import "HTTPRiot/NSString+EscapingUtils.h"
#import "NSDictionary+ParamUtils.h"

@interface HRExtensionsTest : GHTestCase {} @end

@implementation HRExtensionsTest
- (void)testShouldEscapeQueryValues {
    GHAssertEqualStrings([@"foo bar" stringByPreparingForURL], @"foo%20bar", nil);
    GHAssertEqualStrings([@"foo+bar" stringByPreparingForURL], @"foo%2Bbar", nil);
    GHAssertEqualStrings([@"._-~" stringByPreparingForURL], @"._-~", nil);
    GHAssertEqualStrings([@"&=" stringByPreparingForURL], @"%26%3D", nil);
}

- (void)testShouldBuildQueryStringFromDictionary {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Owyn", @"firstname", @"Lyons", @"lastname", nil];
    GHAssertEqualStrings([params toQueryString], @"lastname=Lyons&firstname=Owyn", nil);
}

- (void)testShouldBuildQueryStringWithDuplicateKeysIfParamHasNestedArray {
    NSArray *characters = [NSArray arrayWithObjects:@"Fawkes", @"dogmeat", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObject:characters forKey:@"character"];
    GHAssertEqualStrings([params toQueryString], @"character=Fawkes&character=dogmeat", nil);
    
    NSArray *moreCharacters = [NSArray arrayWithObjects:@"Clover", @"Jericho", nil];
    NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:characters, @"character", moreCharacters, @"more", nil];
    GHAssertEqualStrings([params2 toQueryString], @"more=Clover&more=Jericho&character=Fawkes&character=dogmeat", nil);
    
    NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:characters, @"character", @"Lone Wanderer", @"accompanies", nil];
    GHAssertEqualStrings([params3 toQueryString], @"accompanies=Lone%20Wanderer&character=Fawkes&character=dogmeat", nil);
}
@end
