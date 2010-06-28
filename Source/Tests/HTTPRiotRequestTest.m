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

// - (void)testShouldHandleTimeout {
//     [self prepare];
//     [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:@"Timeout"];
//     [self waitForStatus:kGHUnitWaitStatusFailure timeout:40.0];
// }

- (void)testShouldHandleGET {
    [self prepare];
    [HRTestPerson2 getPath:@"/people.json" withOptions:nil object:@"GET"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testShouldHandlePOST {
    [self prepare];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", 
                                @"foo@email.com", @"email", 
                                @"101 Cherry Lane", @"address", nil];
    id bodyData = [HRFormatJSON encode:body error:nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:bodyData forKey:@"body"];
    
    [HRTestPerson2 postPath:@"/person" withOptions:opts object:@"POST"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testShouldHandlePUT {
    [self prepare];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", 
                                @"foo@email.com", @"email", 
                                @"101 Cherry Lane", @"address", nil];
    NSString *bodyData = [[HRFormatJSON encode:body error:nil] copy];
    NSDictionary *opts = [[NSDictionary alloc ] initWithObjectsAndKeys:bodyData, @"body", nil];
    [bodyData release];
    
    [HRTestPerson2 putPath:@"/person/1" withOptions:opts object:@"PUT"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
    [opts release];
}

- (void)testShouldHandleDELETE {
    [self prepare];
    [HRTestPerson2 deletePath:@"/person/delete/5" withOptions:nil object:@"DELETE"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testShouldHandleBasicAuth {
    [self prepare];
    
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:@"username@email.com", @"username", @"test", @"password", nil];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:auth forKey:@"basicAuth"];
    
    [HRTestPerson2 getPath:@"/auth" withOptions:opts object:@"BasicAuth"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// TODO: Timeout-based tests seem to be having problems on the new GHUnit
// - (void)testShouldHandleCanceledRequest {
//     NSOperation *op = [HRTestPerson2 getPath:@"/timeout" withOptions:nil object:@"CanceledRequest"];
//     [op cancel];
//     GHAssertTrue([op isCancelled], nil); 
// }

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
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testShouldHandleFormattingJSON {
    [self prepare];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"format"];
    [HRTestPerson2 getPath:@"/people.json" withOptions:opts object:@"FormattingJSON"];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)method {
    NSString *prefix = @"testShouldHandle";
    NSString *selector = [prefix stringByAppendingString:method];
    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selector)];
}

- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)method {
    if(method) {
        NSString *prefix = @"testShouldHandle";    
        NSString *selector = [prefix stringByAppendingString:method];
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selector)];   
    }
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
@end
