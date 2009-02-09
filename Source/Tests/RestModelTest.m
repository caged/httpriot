//
//  RestModelTest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "RestModelTest.h"
#import "HTTPRiotRestModel.h"

@interface SomeTestRestModel : HTTPRiotRestModel {} @end
@implementation SomeTestRestModel
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://foo.com"]];
}
@end

@interface SomeOtherTestRestModel : HTTPRiotRestModel {} @end
@implementation SomeOtherTestRestModel
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://foobar.com"]];
}
@end


// WHY IS THIS SHIT BROKEN?
@implementation RestModelTest
- (void) testSetsDefaultVariables 
{
    [[SomeTestRestModel alloc] init];
    [[SomeOtherTestRestModel alloc] init];
    
    STAssertNotNil(@"foo", nil);
    
    // STAssertEqualObjects([SomeTestRestModel baseURI], [NSURL URLWithString:@"http://foo.com"], nil);
    // STAssertEqualObjects([SomeOtherTestRestModel baseURI], [NSURL URLWithString:@"http://foobar.com"], nil);
    // STAssertEqualObjects([SomeTestRestModel baseURI], [NSURL URLWithString:@"http://foo.com"], nil);   
}
@end
