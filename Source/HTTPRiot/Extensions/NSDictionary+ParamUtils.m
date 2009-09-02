//
//  NSDictionary+Misc.m
//  Legislate
//
//  Created by Justin Palmer on 7/24/08.
//  Copyright 2008 Active Reload, LLC. All rights reserved.
//

#import "NSDictionary+ParamUtils.h"
#import "NSString+EscapingUtils.h"

@implementation NSDictionary (ParamUtils)

- (NSString *)toQueryString {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:@""];
    NSArray *keys = [self allKeys];
    int paramCount = [keys count];
    
    for(size_t i = 0; i < paramCount; i++) {
        NSString *key = [keys objectAtIndex:i];
        id value = [self objectForKey:key];
        
        if([value isKindOfClass:[NSArray class]]) {
            for(id subvalue in value) {
                [queryString appendFormat:@"%@=%@", key, [subvalue stringByPreparingForURL]];                
                if(![subvalue isEqualToString:[value lastObject]] || (i < paramCount - 1)) {
                    [queryString appendString:@"&"];
                }
            }
        } else {
            [queryString appendFormat:@"%@=%@", key, [value stringByPreparingForURL]];
            
            if(i < paramCount - 1) {
                [queryString appendString:@"&"];
            }
        }
    }
 
    return [queryString autorelease];
}
@end
