//
//  HTTPRiotRestModel.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/28/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotRestModel.h"
#import "HTTPRiotRequest.h"

@interface HTTPRiotRestModel (PrivateMethods)
+ (void)setAttributeValue:(id)attr forKey:(NSString *)key;
+ (NSMutableDictionary *)classAttributes;
@end

@implementation HTTPRiotRestModel
static NSMutableDictionary *attributes;

+ (void)initialize
{
    if(!attributes)
        attributes = [[NSMutableDictionary dictionary] retain];
}

// Given that we want to allow classes to define default attributes we need to create 
// a classname-based dictionary store that maps a subclass name to a dictionary 
// containing its attributes.
+ (NSMutableDictionary *)classAttributes
{
    NSString *className = NSStringFromClass([self class]);
    
    NSMutableDictionary *newDict;
    NSMutableDictionary *dict = [attributes objectForKey:className];
    if(dict)
    {
        return dict;
    } 
    else
    {
        newDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:kHTTPRiotJSONFormat] forKey:@"format"];
        [attributes setObject:newDict forKey:className];
    }
    
    return newDict;
}

+ (NSURL *)baseURI
{
   return [[self classAttributes] objectForKey:@"baseURI"];
}

+ (void)setBaseURI:(NSURL *)uri
{
    [self setAttributeValue:uri forKey:@"baseURI"];
}

+ (NSDictionary *)headers
{
    return [[self classAttributes] objectForKey:@"headers"];
}

+ (void)setHeaders:(NSDictionary *)hdrs
{
    [self setAttributeValue:hdrs forKey:@"headers"];
}

+ (kHTTPRiotFormat)format
{
    return [[[self classAttributes] objectForKey:@"format"] intValue];
}

+ (void)setFormat:(kHTTPRiotFormat)format
{
    [[self classAttributes] setValue:[NSNumber numberWithInt:format] forKey:@"format"];
}

+ (NSDictionary *)defaultParams
{
    return [[self classAttributes] objectForKey:@"defaultParams"];
}

+ (void)setDefaultParams:(NSDictionary *)params
{
    [self setAttributeValue:params forKey:@"defaultParams"];
}

+ (void)setAttributeValue:(id)attr forKey:(NSString *)key
{
    [[self classAttributes] setObject:attr forKey:key];
}

+ (NSArray *)getPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error
{
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithDictionary:[self classAttributes]];
    [opts addEntriesFromDictionary:options];
    
    return [HTTPRiotRequest requestWithMethod:kHTTPRiotMethodGet path:path options:opts error:error];
}
@end
