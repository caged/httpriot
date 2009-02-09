//
//  HTTPRiotFormatJSON.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/8/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotFormatJSON.h"
#import "JSON.h"

@implementation HTTPRiotFormatJSON
+ (NSString *)extension
{
    return @"json";
}

+ (NSString *)mimeType
{
    return @"application/json";
}

+ (id)decode:(NSData *)data
{
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    id jsonVal = [json JSONValue];
    [json release];
    
    return jsonVal;
}

+ (NSString *)encode:(id)data
{
    return [data JSONRepresentation];
}
@end
