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
    STAssertThrows([HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:@"/status/400" options:nil error:nil], nil);
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
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet
                                              path:[HTTPRiotTestServer stringByAppendingString:@"/foobared-path"]
                                           options:defaultOptions
                                             error:&error];
    NSDictionary *headers = [[error userInfo] valueForKey:@"headers"];
    NSLog(@"%s HEADERS:%@", _cmd, headers);
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

// - (void)testPOST
// {
//     STFail(nil, nil);
// }
// 
// - (void)testPUT
// {
//     STFail(nil, nil);
// }
// 
// - (void)testDELETE
// {
//     STFail(nil, nil);
// }
@end
