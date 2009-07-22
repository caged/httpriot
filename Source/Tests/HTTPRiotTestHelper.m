//
//  HTTPRiotTestHelper.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/11/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotTestHelper.h"

@implementation HRTestPerson
+ (void)initialize  { 
    [self setBaseURL:[NSURL URLWithString:HTTPRiotTestServer]];
    [self setBasicAuthWithUsername:@"username@email.com" password:@"test"]; 
}
@end

@implementation HRTestPerson2 
+ (void)initialize  { 
    [self setBaseURL:[NSURL URLWithString:HTTPRiotTestServer]]; 
}
@end

@implementation HRTestPerson3
+ (void)initialize  { 
    [self setBaseURL:[NSURL URLWithString:HTTPRiotTestServer]]; 
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", @"bing", @"bada", nil];
    [self setHeaders:params];
    [self setDefaultParams:params];
}
@end

@implementation HRTestPerson4
+ (void)initialize  { 
    [self setBaseURL:[NSURL URLWithString:HTTPRiotTestServer]];
    [self setFormat:HRDataFormatXML];
}
@end

@implementation HRTestPerson5 @end
@implementation HRTestPerson6 @end

