//
//  HTTPRiotRestModel.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/28/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotRestModel.h"
#import "HTTPRiotRequestOperation.h"

@interface HTTPRiotRestModel (PrivateMethods)
+ (void)setAttributeValue:(id)attr forKey:(NSString *)key;
+ (NSMutableDictionary *)classAttributes;
+ (NSMutableDictionary *)mergedOptions:(NSDictionary *)options;
@end

@implementation HTTPRiotRestModel
static NSMutableDictionary *attributes;

+ (void)initialize
{
    if(!attributes)
        attributes = [[NSMutableDictionary dictionary] retain];
}

#pragma mark - Class Attributes
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

+ (NSDictionary *)basicAuth
{
    return [[self classAttributes] objectForKey:@"basicAuth"];
}

+ (void)setBasicAuthWithUsername:(NSString *)username password:(NSString *)password
{
    NSDictionary *authDict = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    [self setAttributeValue:authDict forKey:@"basicAuth"];
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

#pragma mark - REST Methods
+ (NSOperation *)getPath:(NSString *)path withOptions:(NSDictionary *)options target:(id)target selector:(SEL)sel
{
    NSMutableDictionary *opts = [self mergedOptions:options];
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodGet path:path options:opts target:target selector:sel];        
}

+ (NSOperation *)getPath:(NSString *)path target:(id)target selector:(SEL)sel
{
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodGet path:path options:[self mergedOptions:nil] target:target selector:sel];        
}

+ (NSOperation *)postPath:(NSString *)path withOptions:(NSDictionary *)options target:(id)target selector:(SEL)sel
{
    NSMutableDictionary *opts = [self mergedOptions:options];
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodPost path:path options:opts target:target selector:sel];        
}

+ (NSOperation *)postPath:(NSString *)path target:(id)target selector:(SEL)sel
{
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodPost path:path options:[self mergedOptions:nil] target:target selector:sel];        
}

+ (NSOperation *)putPath:(NSString *)path withOptions:(NSDictionary *)options target:(id)target selector:(SEL)sel
{
    NSMutableDictionary *opts = [self mergedOptions:options];
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodPut path:path options:opts target:target selector:sel];        
}

+ (NSOperation *)putPath:(NSString *)path target:(id)target selector:(SEL)sel
{
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodPut path:path options:[self mergedOptions:nil] target:target selector:sel];        
}

+ (NSOperation *)deletePath:(NSString *)path withOptions:(NSDictionary *)options target:(id)target selector:(SEL)sel
{
    NSMutableDictionary *opts = [self mergedOptions:options];
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodDelete path:path options:opts target:target selector:sel];        
}

+ (NSOperation *)deletePath:(NSString *)path target:(id)target selector:(SEL)sel
{
    return [HTTPRiotRequestOperation requestWithMethod:kHTTPRiotMethodDelete path:path options:[self mergedOptions:nil] target:target selector:sel];        
}

#pragma mark - Private Methods
+ (NSMutableDictionary *)mergedOptions:(NSDictionary *)options
{
    NSMutableDictionary *defaultParams = [NSMutableDictionary dictionaryWithDictionary:[self defaultParams]];
    [defaultParams addEntriesFromDictionary:[options valueForKey:@"params"]];
    options = [NSMutableDictionary dictionaryWithDictionary:options];
    [(NSMutableDictionary *)options setObject:defaultParams forKey:@"params"];
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithDictionary:[self classAttributes]];
    [opts addEntriesFromDictionary:options];
    [opts removeObjectForKey:@"defaultParams"];

    return opts;
}
@end
