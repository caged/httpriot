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

- (void) testShouldSetFormat 
{
    [HRTestPerson4 setFormat:kHTTPRiotXMLFormat];
    STAssertEquals([HRTestPerson4 format], kHTTPRiotXMLFormat, nil);
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

- (void) testShouldSetBasicAuthCredentials 
{
    NSDictionary *expectedAuth = [NSDictionary dictionaryWithObjectsAndKeys:@"user", @"username", @"pass", @"password", nil];
    NSDictionary *basicAuth = [HRTestPerson basicAuth];
    STAssertEqualObjects(basicAuth, expectedAuth, nil);
}

- (void)testShouldMergeDefaultParamsWithParamsPassedToMethod
{
    // defaultParams: {foo: 'bar', bada: 'bing'}
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"limit", nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    NSDictionary *mergedOpts = [HRTestPerson3 mergedOptions:opts];
    params = [mergedOpts valueForKey:@"params"];
    
    STAssertEqualObjects([params valueForKey:@"limit"], @"5", nil);
    STAssertEqualObjects([params valueForKey:@"bada"], @"bing", nil);
}

- (void)testParamsProvidedInMethodShouldOverideDefaultParams
{
    // defaultParams: {foo: 'bar', bada: 'bing'}
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"123",@"foo", nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    NSDictionary *mergedOpts = [HRTestPerson3 mergedOptions:opts];
    params = [mergedOpts valueForKey:@"params"];
    
    STAssertEqualObjects([params valueForKey:@"foo"], @"123", nil);
    STAssertEqualObjects([params valueForKey:@"bada"], @"bing", nil);
}

- (void) testShouldDecodeJSON 
{
    NSError *error = nil;
    [HRTestPerson4 setFormat:kHTTPRiotJSONFormat];
    id people = [HRTestPerson getPath:@"/people" withOptions:nil error:&error];
    NSArray *person = [people valueForKeyPath:@"people.person"];
    STAssertTrue([person isKindOfClass:[NSArray class]], nil);
    STAssertNil(error, nil);
}

- (void)testShouldDecodeXML
{
    NSError *error = nil;
    [HRTestPerson4 setFormat:kHTTPRiotXMLFormat];
    id people = [HRTestPerson getPath:@"/people" withOptions:nil error:&error];
    NSArray *person = [people valueForKeyPath:@"people.person"];
    STAssertTrue([person isKindOfClass:[NSArray class]], nil);
    STAssertNil(error, nil);
}

- (void) testShouldCreateUniqueClassAttributesForSubClasses
{
    NSDictionary *h5attrs = [HRTestPerson5 classAttributes];
    NSDictionary *h6attrs = [HRTestPerson6 classAttributes];
    NSURL *h5URL = [NSURL URLWithString:@"http://foo.com"];
    NSURL *h6URL = [NSURL URLWithString:@"http://bar.com"];
    [HRTestPerson5 setBaseURI:h5URL];
    [HRTestPerson6 setBaseURI:h6URL];
    
    STAssertEqualObjects([h5attrs objectForKey:@"baseURI"], h5URL, nil);
    STAssertEqualObjects([h6attrs objectForKey:@"baseURI"], h6URL, nil);
}

// - (void) testHostProvidedInPathShouldOverideBaseURI 
// {
//     STFail(nil, nil);
// }
@end
