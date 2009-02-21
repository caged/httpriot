//
//  HTTPRiotRequest.h
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HTTPRiotConstants.h"

/**
 * Request stuff
 */
@interface HTTPRiotRequest : NSObject {
    float timeout;
    kHTTPRiotMethod httpMethod;
    NSString *path;
    NSDictionary *options;
    NSArray *methodStrings;
    id formatter;
}

/// The length of time in seconds before the request times out
/**
 This defaults to 30.0
 */
@property (nonatomic, assign) float timeout;

/// The REST method to use when performing a request
/**
 This defaults to kHTTPRiotMethodGET
 */
@property (nonatomic, assign) kHTTPRiotMethod httpMethod;

/// The relative path or url string used in a request
/**
 If you provide a relative path here, you must set the baseURI option.
 If given a full url this will overide the baseURI option.
 */
@property (nonatomic, readonly, copy) NSString *path;

/// An NSDictionary containing all the options for a request.
/**
 This needs documented
 */
@property (nonatomic, readonly, retain) NSDictionary *options;

/// The formatter used to decode the response body.
/**
 Currently, only JSON is supported.
 */
@property (nonatomic, readonly, retain) id formatter;

/**
 @breif Returns an NSDictionary, NSArray decoded from the server

 You shouldn't have to call this method directly.
 */
+ (id)requestWithMethod:(kHTTPRiotMethod)method
                         path:(NSString*)urlPath
                      options:(NSDictionary*)requestOptions
                        error:(NSError **)error;
@end
