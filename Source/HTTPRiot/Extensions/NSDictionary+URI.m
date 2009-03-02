//
//  NSDictionary+Misc.m
//  Legislate
//
//  Created by Justin Palmer on 7/24/08.
//  Copyright 2008 Active Reload, LLC. All rights reserved.
//

#import "NSDictionary+URI.h"
#import "NSString+URI.h"

@implementation NSDictionary (URI)
- (NSString *)toQueryString
{
    NSMutableString *tmpString = [NSMutableString string];
    for(id key in self) 
    {
        [tmpString appendFormat:@"%@=%@&", key, [[self objectForKey:key] stringByPreparingForURL]];
    }
    return tmpString;
}
@end
