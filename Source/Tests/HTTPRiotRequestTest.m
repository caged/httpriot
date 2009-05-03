//
//  HTTPRiotRequestTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/11/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <HTTPRiot/HTTPRiot.h>
#import "HTTPRiotTestHelper.h"
#import "HTTPRiotFormatJSON.h"

@interface HTTPRiotRequestTest : GHTestCase {} @end
static NSDictionary *defaultOptions;
@implementation HTTPRiotRequestTest

- (void) setUp
{
    defaultOptions = [[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kHTTPRiotJSONFormat]  forKey:@"format"] retain];
}

- (void) tearDown
{
    [defaultOptions release];
}

- (void) testShouldThrowExceptionIfHostIsNotGiven 
{
    NSError *error = nil;
    GHAssertThrows([HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:@"/status/400" options:defaultOptions error:&error], nil);
}

- (void) testShouldHandleResponse 
{   
    NSString *host = HTTPRiotTestServer;
    //BadRequest
    NSError *error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/400"] options:defaultOptions error:&error];    
    GHAssertEquals(400, [error code], nil);
    
    //ForbiddenAccess
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/403"] options:defaultOptions error:&error];        
    GHAssertEquals(403, [error code], nil);
    
    //ResourceNotFound
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/404"] options:defaultOptions error:&error];        
    GHAssertEquals(404, [error code], nil);
    
    //MethodNotAllowed
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/405"] options:defaultOptions error:&error];        
    GHAssertEquals(405, [error code], nil);
    
    //ResourceConflict
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/409"] options:defaultOptions error:&error];        
    GHAssertEquals(409, [error code], nil);
    
    //ResourceInvalid
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/422"] options:defaultOptions error:&error];        
    GHAssertEquals(422, [error code], nil);
    
    //ClientError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/420"] options:defaultOptions error:&error];        
    GHAssertEquals(420, [error code], nil);
    
    //ServerError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/500"] options:defaultOptions error:&error];        
    GHAssertEquals(500, [error code], nil);
    
    //ConnectionError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/999"] options:defaultOptions error:&error];        
    GHAssertEquals(999, [error code], nil);
}

- (void)testHeadersReturnedWithError
{
    NSError *error = nil;
    NSString *tserver = [HTTPRiotTestServer stringByAppendingString:@"/foobared-path"];
    GHTestLog(@"DL%@", defaultOptions);
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet
                                  path:tserver
                               options:defaultOptions
                                 error:&error];

    NSDictionary *headers = [[error userInfo] valueForKey:@"headers"];
    GHAssertTrue([headers count] > 0, nil);

}


- (void)testGET 
{
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person/1"]
                                           options:[NSDictionary dictionary]
                                             error:nil];
    GHAssertNotNil(person, nil);
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
    
    GHAssertEqualObjects([person valueForKey:@"name"], @"bob", nil);
    GHAssertNil(error, nil);
}

- (void)testPOSTWithFormData 
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
                                             
    GHAssertNil(person, nil);
    GHAssertNil(error, nil);
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
                                             
    GHAssertTrue(person2 == nil && error == nil, nil);
}

- (void)testDELETE
{
    NSError *error = nil;
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodDelete
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/person/1"]
                                           options:defaultOptions
                                             error:&error];
    
    GHAssertNil(person, nil);
    GHAssertNULL(error, @"Error Should've been nil.  Got: %d ERROR: %@", [error code], [error localizedDescription]);
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
    GHAssertNotNil(person, nil);
    GHAssertNil(error, nil);
}
@end
