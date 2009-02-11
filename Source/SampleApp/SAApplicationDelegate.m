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
    
    NSError *error;
    // NSArray *people = [SAPerson getPath:@"/people" withOptions:nil error:&error];
    //    NSDictionary *person = [SAPerson getPath:@"/person/1" withOptions:nil error:&error];
    // id person2 = [SAPerson getPath:@"/people" withOptions:nil error:&error];    
    // person2 = [SAPerson getPath:@"/anotherinvalidpath" withOptions:nil error:nil];
    // NSLog(@"%s PERSON 2:%@", _cmd, [person2 class]);
    // NSLog(@"%s PEOPLE:%@", _cmd, people);
    // NSLog(@"%s PERSON:%@", _cmd, person);
    
    id people = [SAPerson getPath:@"/status/400" withOptions:nil error:&error];
}
@end
