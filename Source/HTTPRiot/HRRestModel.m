//
//  HRRestModel.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/28/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HRRestModel.h"
#import "HRRequestOperation.h"

@interface HRRestModel (PrivateMethods)
+ (void)setAttributeValue:(id)attr forKey:(NSString *)key;
+ (NSMutableDictionary *)classAttributes;
+ (NSMutableDictionary *)mergedOptions:(NSDictionary *)options;
+ (NSOperation *)requestWithMethod:(HRRequestMethod)method path:(NSString *)path options:(NSDictionary *)options object:(id)obj;
@end

@implementation HRRestModel
static NSMutableDictionary *attributes;

+ (void)initialize {    
    if(!attributes)
        attributes = [[NSMutableDictionary dictionary] retain];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class Attributes

// Given that we want to allow classes to define default attributes we need to create 
// a classname-based dictionary store that maps a subclass name to a dictionary 
// containing its attributes.
+ (NSMutableDictionary *)classAttributes {
    NSString *className = NSStringFromClass([self class]);
    
    NSMutableDictionary *newDict;
    NSMutableDictionary *dict = [attributes objectForKey:className];
    
    if(dict) {
        return dict;
    } else {
        newDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:HRDataFormatJSON] forKey:@"format"];
        [attributes setObject:newDict forKey:className];
    }
    
    return newDict;
}

+ (NSObject *)delegate {
   return [[self classAttributes] objectForKey:@"delegate"];
}

+ (void)setDelegate:(NSObject *)del {
    [self setAttributeValue:del forKey:@"delegate"];
}

+ (NSURL *)baseURL {
   return [[self classAttributes] objectForKey:@"baseURL"];
}

+ (void)setBaseURL:(NSURL *)uri {
    [self setAttributeValue:uri forKey:@"baseURL"];
}

+ (NSDictionary *)headers {
    return [[self classAttributes] objectForKey:@"headers"];
}

+ (void)setHeaders:(NSDictionary *)hdrs {
    [self setAttributeValue:hdrs forKey:@"headers"];
}

+ (NSDictionary *)basicAuth {
    return [[self classAttributes] objectForKey:@"basicAuth"];
}

+ (void)setBasicAuthWithUsername:(NSString *)username password:(NSString *)password {
    NSDictionary *authDict = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    [self setAttributeValue:authDict forKey:@"basicAuth"];
}

+ (HRDataFormat)format {
    return [[[self classAttributes] objectForKey:@"format"] intValue];
}

+ (void)setFormat:(HRDataFormat)format {
    [[self classAttributes] setValue:[NSNumber numberWithInt:format] forKey:@"format"];
}

+ (NSDictionary *)defaultParams {
    return [[self classAttributes] objectForKey:@"defaultParams"];
}

+ (void)setDefaultParams:(NSDictionary *)params {
    [self setAttributeValue:params forKey:@"defaultParams"];
}

+ (void)setAttributeValue:(id)attr forKey:(NSString *)key {
    [[self classAttributes] setObject:attr forKey:key];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - REST Methods

+ (NSOperation *)getPath:(NSString *)path withOptions:(NSDictionary *)options object:(id)obj {
    return [self requestWithMethod:HRRequestMethodGet path:path options:options object:obj];               
}

+ (NSOperation *)postPath:(NSString *)path withOptions:(NSDictionary *)options object:(id)obj {
    return [self requestWithMethod:HRRequestMethodPost path:path options:options object:obj];                
}

+ (NSOperation *)putPath:(NSString *)path withOptions:(NSDictionary *)options object:(id)obj {
    return [self requestWithMethod:HRRequestMethodPut path:path options:options object:obj];              
}

+ (NSOperation *)deletePath:(NSString *)path withOptions:(NSDictionary *)options object:(id)obj {
    return [self requestWithMethod:HRRequestMethodDelete path:path options:options object:obj];        
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

+ (NSOperation *)requestWithMethod:(HRRequestMethod)method path:(NSString *)path options:(NSDictionary *)options object:(id)obj {
    NSMutableDictionary *opts = [self mergedOptions:options];
    return [HRRequestOperation requestWithMethod:method path:path options:opts object:obj];
}

+ (NSMutableDictionary *)mergedOptions:(NSDictionary *)options {
    NSMutableDictionary *defaultParams = [NSMutableDictionary dictionaryWithDictionary:[self defaultParams]];
    [defaultParams addEntriesFromDictionary:[options valueForKey:@"params"]];
    options = [NSMutableDictionary dictionaryWithDictionary:options];
    [(NSMutableDictionary *)options setObject:defaultParams forKey:@"params"];
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithDictionary:[self classAttributes]];
    [opts addEntriesFromDictionary:options];
    [opts removeObjectForKey:@"defaultParams"];
    NSLog(@"opts:%@", opts);
    return opts;
}
@end
