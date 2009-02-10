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


@implementation RestModelTest
- (void) testSetsBaseURI 
{   
    STAssertEqualObjects(@"http://localhost:4567", [[HRTestPerson baseURI] absoluteString], nil);
    STAssertEqualObjects([NSURL URLWithString:@"http://localhost:4567/people"], [HRTestPerson2 baseURI], nil);
}

- (void)testDefaultFormatIsJSON
{
    STAssertEquals([HRTestPerson format], kHTTPRiotJSONFormat, nil);
}

- (void)test404Error
{
    [HRTestPerson getPath:@"/invalidpath" withOptions:nil];
}
@end
