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
    [self setFormat:kHTTPRiotXMLFormat];
    [self setBaseURI:[NSURL URLWithString:@"http://localhost:4567"]];
}
@end

@interface SAXMLPerson : HTTPRiotRestModel {} @end

@implementation SAXMLPerson
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://localhost:4567"]];
    [self setFormat:kHTTPRiotXMLFormat];
}
@end



@implementation SAApplicationDelegate
- (void)awakeFromNib
{                                                                                             
    NSOperation *op =  [SAPerson getPath:@"http://www.govtrack.us/data/us/111/repstats/people.xml"  target:self selector:@selector(peopleLoaded:)];    
    [op cancel];
    //NSOperation *op2 = [SAPerson getPath:@"http://www.govtrack.us/data/us/111/repstats/people.xml" target:self selector:@selector(peopleLoaded:)];
    //NSOperation *op3 = [SAPerson getPath:@"http://www.govtrack.us/data/us/111/repstats/people.xml" target:self selector:@selector(peopleLoaded:)];
    //NSOperation *op4 = [SAPerson getPath:@"http://www.govtrack.us/data/us/111/repstats/people.xml" target:self selector:@selector(peopleLoaded:)];
}

/**
 * dict contains 'response', 'results' and 'error'
 */
- (void)peopleLoaded:(NSDictionary *)dict
{
    NSLog(@"HAR HAR HAR:%i", [[dict valueForKey:@"response"] statusCode]);
}
@end
