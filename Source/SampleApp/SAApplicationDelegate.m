    //
//  SAApplicationDelegate.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "SAApplicationDelegate.h"
#import <HTTPRiot/HTTPRiot.h>

// @interface SAProject : HTTPRiotRestModel
// {
// }
// @end
// 
// @implementation SAProject
// + (void)initialize
// {
//     [self setBaseURI:[NSURL URLWithString:@"http://alternateidea.com"]];
// }
// @end
// 
@interface SAPerson : HTTPRiotRestModel {} @end
@implementation SAPerson
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://localhost:4567"]];
}
@end


@implementation SAApplicationDelegate
- (void)awakeFromNib
{
    // NSArray *tweets = [SATweet getPath:@"statuses/public_timeline.json" withOptions:nil];
    // for(NSDictionary *tweet in tweets)
    // {
    //     NSLog(@"%s TWEET:%@", _cmd, [tweet valueForKey:@"text"]);
    // }
    
    NSError *error = nil;
    [SAPerson getPath:@"/foobar" withOptions:nil error:&error];
    NSLog(@"%s ERROR:%@", _cmd, error);
}
@end
