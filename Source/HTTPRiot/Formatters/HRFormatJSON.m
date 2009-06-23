//
//  HRFormatJSON.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/8/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HRFormatJSON.h"
#import "JSON.h"

@implementation HRFormatJSON
+ (NSString *)extension {
    return @"json";
}

+ (NSString *)mimeType {
    return @"application/json";
}

+ (id)decode:(NSData *)data {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    id jsonVal = [json JSONValue];
    [json release];
    
    return jsonVal;
}

+ (NSString *)encode:(id)data {
    return [data JSONRepresentation];
}
@end
