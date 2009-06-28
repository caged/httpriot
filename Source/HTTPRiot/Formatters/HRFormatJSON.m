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

+ (id)decode:(NSData *)data error:(NSError **)error {
    NSString *rawString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *parseError = nil;
    SBJSON *parser = [[SBJSON alloc] init];
    id results = [parser objectWithString:rawString error:&parseError];
    [parser release];
    
    if(parseError && !results) {
        *error = parseError;
        return nil;
    }
    
    return results;
}

+ (NSString *)encode:(id)data error:(NSError **)error {
    return [data JSONRepresentation];
}
@end
