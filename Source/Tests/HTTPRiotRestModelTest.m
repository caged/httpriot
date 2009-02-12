//
//  RestModelTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotTestHelper.h"

@interface HTTPRiotRestModelTest : SenTestCase {} @end

@implementation HTTPRiotRestModelTest
- (void) testSetsBaseURI 
{   
    STAssertEqualObjects(@"http://localhost:4567", [[HRTestPerson baseURI] absoluteString], nil);
    STAssertEqualObjects([NSURL URLWithString:@"http://localhost:4567/people"], [HRTestPerson2 baseURI], nil);
}

- (void)testDefaultFormatIsJSON
{
    STAssertEquals([HRTestPerson format], kHTTPRiotJSONFormat, nil);
}

- (void)testShouldProvideErrorIfRequestFails
{
    NSError *error = nil;
    [HRTestPerson getPath:@"/invalidpath" withOptions:nil error:&error];
    STAssertEquals(404, [error code], nil);
}

- (void) testShouldReturnNilIfGivenInvalidPathAndErrorWasntProvided 
{
    id person = [HRTestPerson getPath:@"/another-invalid-path" withOptions:nil error:nil];
    STAssertNil(person, nil);
}

- (void)testShouldUseParamsWhenProvided
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"limit", @"foo", @"bar", nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    NSArray *people = [HRTestPerson getPath:@"/search" withOptions:opts error:nil];
    STAssertTrue([people count] <= 4, nil);
}

- (void)testShouldSetDefaultHeaders
{
    NSDictionary *headers = [HRTestPerson3 headers];
    STAssertEqualObjects(@"bar", [headers objectForKey:@"foo"], nil);
    STAssertEqualObjects(@"bing", [headers objectForKey:@"bada"], nil);
}

- (void)testShouldSetDefaultParams
{
    NSDictionary *params = [HRTestPerson3 defaultParams];
    STAssertEqualObjects(@"bar", [params objectForKey:@"foo"], nil);
    STAssertEqualObjects(@"bing", [params objectForKey:@"bada"], nil);
}

// - (void) testHostProvidedInPathShouldOverideBaseURI 
// {
//     STFail(nil, nil);
// }
@end
