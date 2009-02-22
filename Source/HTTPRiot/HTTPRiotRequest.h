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
 * The object which all requests are routed through.  You shouldn't need to use 
 * this class directly, but instead use HTTPRiotRestModel which wraps the method 
 * of this class neatly.
 */
@interface HTTPRiotRequest : NSObject {
    float timeout;
    kHTTPRiotMethod httpMethod;
    NSString *path;
    NSDictionary *options;
    id formatter;
}
 
/// The lenght of time in seconds before the request times out.
/**
 * Sets the length of time in seconds before a request will timeout.
 * This defaults to <tt>30.0</tt>.
 */
@property (nonatomic, assign) float timeout;

/// The REST method to use when performing a request
/**
 * This defaults to kHTTPRiotMethodGet.  Valid options are ::kHTTPRiotMethod.
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
 Returns an NSDictionary, NSArray decoded from the server

 You shouldn't have to call this method directly.
 */
+ (id)requestWithMethod:(kHTTPRiotMethod)method
                         path:(NSString*)urlPath
                      options:(NSDictionary*)requestOptions
                        error:(NSError **)error;
@end
