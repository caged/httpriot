//
//  HTTPRiotRequestOperationTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/11/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <HTTPRiot/HTTPRiot.h>
#import "HTTPRiotTestHelper.h"
#import "HRFormatJSON.h"

@interface HRRequestOperationTest : GHAsyncTestCase {
} 
@end

@implementation HRRequestOperationTest

- (void)setUpClass {
    [HRTestPerson2 setDelegate:self];
}

// - (void)testShouldHandleGET {
//     [self prepare];
//     [HRTestPerson2 getPath:@"/people.json" withOptions:nil object:@"GET"];
//     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
// }
// 
// - (void)testShouldHandlePOST {
//     [self prepare];
//     NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", 
//                                 @"foo@email.com", @"email", 
//                                 @"101 Cherry Lane", @"address", nil];
//     id bodyData = [HRFormatJSON encode:body error:nil];
//     NSDictionary *opts = [NSDictionary dictionaryWithObject:bodyData forKey:@"body"];
//     
//     [HRTestPerson2 postPath:@"/person" withOptions:opts object:@"POST"];
//     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
// }
// 
// - (void)testShouldHandlePUT {
//     [self prepare];
//     NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", 
//                                 @"foo@email.com", @"email", 
//                                 @"101 Cherry Lane", @"address", nil];
//     NSString *bodyData = [[HRFormatJSON encode:body error:nil] copy];
//     NSDictionary *opts = [[NSDictionary alloc ] initWithObjectsAndKeys:bodyData, @"body", nil];
//     
//     [HRTestPerson2 putPath:@"/person/1" withOptions:opts object:@"PUT"];
//     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
//     [opts release];
// }
// 
// - (void)testShouldHandleDELETE {
//     [self prepare];
//     [HRTestPerson2 deletePath:@"/person/delete/5" withOptions:nil object:@"DELETE"];
//     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
// }
// 
// - (void)testShouldHandleBasicAuth {
//     [self prepare];
//     
//     NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:@"user", @"username", @"pass", @"password", nil];
//     NSDictionary *opts = [NSDictionary dictionaryWithObject:auth forKey:@"basicAuth"];
//     
//     [HRTestPerson2 getPath:@"/auth" withOptions:opts object:@"BasicAuth"];
//     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
// }
// 
// // - (void)testShouldHandleTimeOut {
// //     [self prepare];
// //     [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:@"TimeOut"];
// //     [self waitForStatus:kGHUnitWaitStatusFailure timeout:40.0];
// // }
// 
// - (void)testShouldHandleCanceledRequest {
//     NSOperation *op = [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:@"CanceledRequest"];
//     [op cancel];
//     GHAssertTrue([op isCancelled], nil); 
// }
// 
// - (void)testShouldCancelAllRequests {
//     [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:nil];
//     [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:nil];
//     [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:nil];
//     
//     [[HROperationQueue sharedOperationQueue] cancelAllOperations];
//     GHAssertTrue([[[HROperationQueue sharedOperationQueue] operations] count] == 0, nil); 
// }

- (void)testShouldHandleFormattingXML {
    [self prepare];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"format"];
    [HRTestPerson2 getPath:@"/people.xml" withOptions:opts object:@"FormattingXML"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];
}

- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)method {
    NSString *prefix = @"testShouldHandle";
    NSLog(@"RESOURCE:%@", resource);
    NSString *selector = [prefix stringByAppendingString:method];
    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selector)];
}

- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)method {
    NSString *prefix = @"testShouldHandle";    
    NSString *selector = [prefix stringByAppendingString:method];
    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selector)];
}

- (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)method {
    NSString *prefix = @"testShouldHandle";
    NSString *selector = [prefix stringByAppendingString:method];
    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selector)];
}

- (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error responseBody:(NSString *)string object:(id)method {
    NSString *prefix = @"testShouldHandle";
    NSString *selector = [prefix stringByAppendingString:method];
    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selector)];
}

// - (void) testShouldThrowExceptionIfHostIsNotGiven 
// {
//     NSError *error = nil;
//     GHAssertThrows([HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:@"/status/400" options:defaultOptions error:&error], nil);
// }
// 
// - (void) testShouldHandleResponse 
// {   
//     NSString *host = HTTPRiotTestServer;
//     //BadRequest
//     NSError *error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/400"] options:defaultOptions error:&error];    
//     GHAssertEquals(400, [error code], nil);
//     
//     //ForbiddenAccess
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/403"] options:defaultOptions error:&error];        
//     GHAssertEquals(403, [error code], nil);
//     
//     //ResourceNotFound
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/404"] options:defaultOptions error:&error];        
//     GHAssertEquals(404, [error code], nil);
//     
//     //MethodNotAllowed
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/405"] options:defaultOptions error:&error];        
//     GHAssertEquals(405, [error code], nil);
//     
//     //ResourceConflict
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/409"] options:defaultOptions error:&error];        
//     GHAssertEquals(409, [error code], nil);
//     
//     //ResourceInvalid
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/422"] options:defaultOptions error:&error];        
//     GHAssertEquals(422, [error code], nil);
//     
//     //ClientError
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/420"] options:defaultOptions error:&error];        
//     GHAssertEquals(420, [error code], nil);
//     
//     //ServerError
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/500"] options:defaultOptions error:&error];        
//     GHAssertEquals(500, [error code], nil);
//     
//     //ConnectionError
//     error = nil;
//     [HTTPRiotRequestOperation requestWithMethod:HRRequestMethodGet path:[host stringByAppendingString:@"/status/999"] options:defaultOptions error:&error];        
//     GHAssertEquals(999, [error code], nil);
// }
@end
