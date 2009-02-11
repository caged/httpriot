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

@implementation HTTPRiotRequestTest

- (void) testShouldThrowExceptionIfHostIsNotGiven 
{
    STAssertThrows([HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:@"/status/400" options:nil error:nil], nil);
}

- (void) testShouldHandleResponse 
{   
    NSString *host = @"http://localhost:4567";
    //BadRequest
    NSError *error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/400"] options:nil error:&error];    
    STAssertEquals(400, [error code], nil);
    
    //ForbiddenAccess
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/403"] options:nil error:&error];        
    STAssertEquals(403, [error code], nil);
    
    //ResourceNotFound
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/404"] options:nil error:&error];        
    STAssertEquals(404, [error code], nil);
    
    //MethodNotAllowed
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/405"] options:nil error:&error];        
    STAssertEquals(405, [error code], nil);
    
    //ResourceConflict
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/409"] options:nil error:&error];        
    STAssertEquals(409, [error code], nil);
    
    //ResourceInvalid
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/422"] options:nil error:&error];        
    STAssertEquals(422, [error code], nil);
    
    //ClientError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/420"] options:nil error:&error];        
    STAssertEquals(420, [error code], nil);
    
    //ServerError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/500"] options:nil error:&error];        
    STAssertEquals(500, [error code], nil);
    
    //ConnectionError
    error = nil;
    [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:[host stringByAppendingString:@"/status/999"] options:nil error:&error];        
    STAssertEquals(999, [error code], nil);
}

- (void) testGET 
{
    id person = [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:@"/person/1" options:nil error:nil];
    STAssertNotNil(person, nil);
}

- (void)testPOST
{
    STFail(nil, nil);
}

- (void)testPUT
{
    STFail(nil, nil);
}

- (void)testDELETE
{
    STFail(nil, nil);
}
@end
