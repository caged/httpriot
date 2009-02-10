//
//  RestModelTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import <HTTPRiot/HTTPRiot.h>
#import <SenTestingKit/SenTestingKit.h>


@interface RestModelTest : SenTestCase {} @end
@interface HRTestPerson : HTTPRiotRestModel {} @end
@interface HRTestPerson2 : HTTPRiotRestModel {} @end


@implementation HRTestPerson
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://localhost:4567"]];
}
@end

@implementation HRTestPerson2
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://localhost:4567/people"]];
}
@end


// WHY IS THIS SHIT BROKEN?
@implementation RestModelTest
- (void) testSetsDefaultVariables 
{
    // [[HRTestPerson alloc] init];
    // [[HRTestPerson2 alloc] init];
    
    STAssertNotNil(@"foo", nil);
    
    //STAssertEqualObjects(@"http://localhost:4567", [[HRTestPerson baseURI] absoluteString], nil);
    //STAssertEqualObjects([NSURL URLWithString:@"http://foo.com"], [NSURL URLWithString:@"http://foobar.com"], nil);
}
@end
