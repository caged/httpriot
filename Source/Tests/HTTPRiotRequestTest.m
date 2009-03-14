//
//  HTTPRiotRequestTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/11/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <HTTPRiot/HTTPRiot.h>
#import <SenTestingKit/SenTestingKit.h>
#import "HTTPRiotTestHelper.h"
#import "HTTPRiotFormatJSON.h"

@interface HTTPRiotRequestTest : SenTestCase {} @end
static NSDictionary *defaultOptions;
@implementation HTTPRiotRequestTest

+ (void)initialize
{
    if(!defaultOptions)
        defaultOptions = [[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kHTTPRiotJSONFormat]  forKey:@"format"] retain];
}

- (void) testShouldThrowExceptionIfHostIsNotGiven 
{
    NSError *error = nil;
    STAssertThrows([HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:@"/status/400" options:defaultOptions error:&error], nil);
}

- (void) testShouldHandleResponse 
{   
    NSString *host = HTTPRiotTestServer;
    //BadRequest
    NSError *error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/400"] options:defaultOptions error:&error];    
    STAssertEquals(400, [error code], nil);
    
    //ForbiddenAccess
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/403"] options:defaultOptions error:&error];        
    STAssertEquals(403, [error code], nil);
    
    //ResourceNotFound
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/404"] options:defaultOptions error:&error];        
    STAssertEquals(404, [error code], nil);
    
    //MethodNotAllowed
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/405"] options:defaultOptions error:&error];        
    STAssertEquals(405, [error code], nil);
    
    //ResourceConflict
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/409"] options:defaultOptions error:&error];        
    STAssertEquals(409, [error code], nil);
    
    //ResourceInvalid
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/422"] options:defaultOptions error:&error];        
    STAssertEquals(422, [error code], nil);
    
    //ClientError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/420"] options:defaultOptions error:&error];        
    STAssertEquals(420, [error code], nil);
    
    //ServerError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/500"] options:defaultOptions error:&error];        
    STAssertEquals(500, [error code], nil);
    
    //ConnectionError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/999"] options:defaultOptions error:&error];        
    STAssertEquals(999, [error code], nil);
}

- (void)testHeadersReturnedWithError
{
    NSError *error;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet
                                  path:[HTTPRiotTestServer stringByAppendingString:@"/foobared-path"]
                               options:defaultOptions
                                 error:&error];
    NSDictionary *headers = [[error userInfo] valueForKey:@"headers"];
    STAssertTrue([headers count] > 0, nil);
}

- (void) testGET 
{
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person/1"]
                                           options:defaultOptions
                                             error:nil];
    STAssertNotNil(person, nil);
}

- (void)testPOSTWithRawBody
{
    NSError *error = nil;
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", 
                                @"foo@email.com", @"email", 
                                @"101 Cherry Lane", @"address", nil];
    NSDictionary *headers = [NSDictionary dictionaryWithObject:[HTTPRiotFormatJSON mimeType] forKey:@"Content-Type"];
    id bodyData = [HTTPRiotFormatJSON encode:body];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:bodyData, @"body", 
                                        headers, @"headers", nil];                       
    [options addEntriesFromDictionary:defaultOptions];
    
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodPost
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person"]
                                           options:options
                                             error:&error];
    
    STAssertEqualObjects([person valueForKey:@"name"], @"bob", nil);
    STAssertNil(error, nil);
}

- (void) testPOSTWithFormData 
{
    NSError *error = nil;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", 
                                @"foo@email.com", @"email", 
                                @"101 Cherry Lane", @"address", nil];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObject:params forKey:@"params"];                       
    [options addEntriesFromDictionary:defaultOptions];
    
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodPost
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person/form-data"]
                                           options:options
                                             error:&error];
                                             
    STAssertNil(person, nil);
    STAssertNil(error, nil);
}

- (void)testPUTWithRawBody
{
    id person = [HRTestPerson getPath:@"/person/1" withOptions:nil error:nil];
    
    NSMutableDictionary *updatedPerson = [NSMutableDictionary dictionaryWithDictionary:person];
    [updatedPerson setValue:@"Justin" forKey:@"name"];
    [updatedPerson setValue:@"encytemedia@gamil.com" forKey:@"email"];
    [updatedPerson removeObjectForKey:@"id"];
    
    NSDictionary *headers = [NSDictionary dictionaryWithObject:[HTTPRiotFormatJSON mimeType] forKey:@"Content-Type"];
    id bodyData = [HTTPRiotFormatJSON encode:updatedPerson];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:bodyData, @"body", 
                                        headers, @"headers", nil];
    [options addEntriesFromDictionary:defaultOptions];
    
    NSError *error = nil;
    id person2 = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodPut
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person/1"]
                                           options:options
                                             error:&error];
                                             
    STAssertTrue(person2 == nil && error == nil, nil);
}

- (void)testDELETE
{
    NSError *error = nil;
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodDelete
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person/1"]
                                           options:defaultOptions
                                             error:nil];
    
    STAssertTrue(person == nil && error == nil, nil);
}

- (void) testBasicAuth 
{
    NSError *error = nil;
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:@"user", @"username", @"pass", @"password", nil];
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithDictionary:defaultOptions];
    [opts addEntriesFromDictionary:[NSDictionary dictionaryWithObject:auth forKey:@"basicAuth"]];
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/auth"]
                                           options:opts
                                             error:&error];
    STAssertNotNil(person, nil);
    STAssertNil(error, nil);
}
@end
