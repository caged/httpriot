//
//  HTTPRiotFormatXML.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/8/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotFormatXML.h"

@implementation HTTPRiotFormatXML
+ (NSString *)extension
{
    return @"xml";
}

+ (NSString *)mimeType
{
    return @"application/xml";
}

+ (id)decode:(NSData *)data
{
    NSAssert(true, @"omg it's broke");
    return nil;
}

+ (NSString *)encode:(id)data
{
    NSAssert(true, @"omg it's broke");
    return nil;
}

@end
