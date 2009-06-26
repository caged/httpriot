//
//  RestModelTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotTestHelper.h"

@interface HRRestModelTest : GHTestCase {} @end

@implementation HRRestModelTest
- (void) testSetsBaseURI 
{   
    GHAssertEqualObjects(@"http://localhost:4567", [[HRTestPerson baseURI] absoluteString], nil);
    GHAssertEqualObjects([NSURL URLWithString:@"http://localhost:4567/people"], [HRTestPerson2 baseURI], nil);
}

- (void)testDefaultFormatIsJSON
{
    GHAssertEquals([HRTestPerson format], HRDataFormatJSON, nil);
}

- (void) testShouldSetFormat 
{
    [HRTestPerson4 setFormat:HRDataFormatXML];
    GHAssertEquals([HRTestPerson4 format], HRDataFormatXML, nil);
}

- (void)testShouldSetDefaultHeaders
{
    NSDictionary *headers = [HRTestPerson3 headers];
    GHAssertEqualObjects(@"bar", [headers objectForKey:@"foo"], nil);
    GHAssertEqualObjects(@"bing", [headers objectForKey:@"bada"], nil);
}

- (void)testShouldSetDefaultParams
{
    NSDictionary *params = [HRTestPerson3 defaultParams];
    GHAssertEqualObjects(@"bar", [params objectForKey:@"foo"], nil);
    GHAssertEqualObjects(@"bing", [params objectForKey:@"bada"], nil);
}

- (void) testShouldSetBasicAuthCredentials 
{
    NSDictionary *expectedAuth = [NSDictionary dictionaryWithObjectsAndKeys:@"user", @"username", @"pass", @"password", nil];
    NSDictionary *basicAuth = [HRTestPerson basicAuth];
    GHAssertEqualObjects(basicAuth, expectedAuth, nil);
}

- (void)testShouldMergeDefaultParamsWithParamsPassedToMethod
{
    // defaultParams: {foo: 'bar', bada: 'bing'}
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"limit", nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    NSDictionary *mergedOpts = [HRTestPerson3 mergedOptions:opts];
    params = [mergedOpts valueForKey:@"params"];
    
    GHAssertEqualObjects([params valueForKey:@"limit"], @"5", nil);
    GHAssertEqualObjects([params valueForKey:@"bada"], @"bing", nil);
}

- (void)testParamsProvidedInMethodShouldOverideDefaultParams
{
    // defaultParams: {foo: 'bar', bada: 'bing'}
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"123",@"foo", nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    NSDictionary *mergedOpts = [HRTestPerson3 mergedOptions:opts];
    params = [mergedOpts valueForKey:@"params"];
    
    GHAssertEqualObjects([params valueForKey:@"foo"], @"123", nil);
    GHAssertEqualObjects([params valueForKey:@"bada"], @"bing", nil);
}

// - (void) testShouldDecodeJSON 
// {
//     NSError *error = nil;
//     [HRTestPerson4 setFormat:HRFormatJSON];
//     id people = [HRTestPerson getPath:@"/people" withOptions:nil error:&error];
//     NSArray *person = [people valueForKeyPath:@"people.person"];
//     GHAssertTrue([person isKindOfClass:[NSArray class]], nil);
//     GHAssertNil(error, nil);
// }
// 
// - (void)testShouldDecodeXML
// {
//     NSError *error = nil;
//     [HRTestPerson4 setFormat:kHTTPRiotXMLFormat];
//     id people = [HRTestPerson getPath:@"/people" withOptions:nil error:&error];
//     NSArray *person = [people valueForKeyPath:@"people.person"];
//     GHAssertTrue([person isKindOfClass:[NSArray class]], nil);
//     GHAssertNil(error, nil);
// }

- (void) testShouldCreateUniqueClassAttributesForSubClasses
{
    NSDictionary *h5attrs = [HRTestPerson5 classAttributes];
    NSDictionary *h6attrs = [HRTestPerson6 classAttributes];
    NSURL *h5URL = [NSURL URLWithString:@"http://foo.com"];
    NSURL *h6URL = [NSURL URLWithString:@"http://bar.com"];
    [HRTestPerson5 setBaseURI:h5URL];
    [HRTestPerson6 setBaseURI:h6URL];
    
    GHAssertEqualObjects([h5attrs objectForKey:@"baseURI"], h5URL, nil);
    GHAssertEqualObjects([h6attrs objectForKey:@"baseURI"], h6URL, nil);
}

// - (void) testHostProvidedInPathShouldOverideBaseURI 
// {
//     STFail(nil, nil);
// }
@end
