//
//  HTTPRiotRestModel.h
//  HTTPRiot
//
//  Created by Justin Palmer on 1/28/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HTTPRiotConstants.h"

@interface HTTPRiotRestModel : NSObject {

}

+ (NSURL *)baseURI;
+ (void)setBaseURI:(NSURL *)uri;

+ (NSDictionary *)headers;
+ (void)setHeaders:(NSDictionary *)hdrs;

+ (NSDictionary *)basicAuth;
+ (void)setBasicAuthWithUsername:(NSString *)username password:(NSString *)password;

+ (NSDictionary *)defaultParams;
+ (void)setDefaultParams:(NSDictionary *)params;

+ (kHTTPRiotFormat)format;
+ (void)setFormat:(kHTTPRiotFormat)format;

+ (NSArray *)getPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
+ (NSArray *)postPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
+ (NSArray *)putPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
+ (NSArray *)deletePath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
@end
