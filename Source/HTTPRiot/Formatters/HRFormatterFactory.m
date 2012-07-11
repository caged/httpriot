//
//  HRFormatterFactory.m
//  HTTPRiot
//
//  Created by Ognen Ivanovski on 10-12-27.
//  Copyright 2010 Netcetera Skopje. All rights reserved.
//

#import "HRGlobal.h"
#import "HRFormatterFactory.h"
#import "HRFormatJSON.h"
#import "HRFormatXML.h"

@implementation HRFormatterFactory

static NSMutableDictionary *registry = nil;

+ (NSMutableDictionary *)formatters
{
    if (registry == nil) {
        registry = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    [[[HRFormatJSON alloc] init] autorelease],      [NSNumber numberWithInteger:HRDataFormatJSON],
                    [[[HRFormatXML alloc] init] autorelease],       [NSNumber numberWithInteger:HRDataFormatXML],
                    nil];
    }
    
    return registry;
}


+ (void)registerFormatter:(id <HRFormatterProtocol>)formatter forFormat:(NSUInteger)format
{
    [[self formatters] setObject:formatter forKey:[NSNumber numberWithInteger:format]];
}

+ (id <HRFormatterProtocol>) formatterForFormat:(NSUInteger)format
{
    id <HRFormatterProtocol> result = [[self formatters] objectForKey:[NSNumber numberWithInteger:format]];
    
    if (!result) {
        [NSException raise:NSInvalidArgumentException
                    format:@"There is no formatter for the specified format identifier registered"];
    }
    
    return result;
}

+ (void)resetRegistry
{
    [registry release];
    registry = nil;
}
@end
