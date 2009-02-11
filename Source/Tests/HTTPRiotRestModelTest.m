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
    STAssertNotNil(person, nil);
}

- (void) testHostProvidedInPathShouldOverideBaseURI 
{
    STFail(nil, nil);
}
@end
