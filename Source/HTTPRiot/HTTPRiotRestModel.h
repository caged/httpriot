//
//  HTTPRiotRestModel.h
//  HTTPRiot
//
//  Created by Justin Palmer on 1/28/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HTTPRiotConstants.h"

/**
 * You can either subclass this class or use it directly to make requests.
 * It's recommended that you subclass it and setup default properties in your 
 * classes <tt>initialize</tt> method.
 *
 * @code
 *  @implementation Person
 *  + (void)initialize
 *  {
 *     NSDictionary *params = [NSDictionary dictionaryWithObject:@"1234567" forKey:@"api_key"];
 *     [self setBaseURI:[NSURL URLWithString:@"http://localhost:1234/api"]];    
 *     [self setFormat:kHTTPFormatJSON];
 *     [self setDefaultParameters:params];
 *  }
 *  @end
 *
 *  // Would send a request to http://localhost:1234/api/people/1?api_key=1234567
 *  [Person getPath:@"/people/1" withOptions:nil error:nil];
 * @endcode
 *
 * <h3>A note on default properties and subclassing</h3>
 * Each subclass has its own set of unique properties and these properties <em>are not</em>
 * inherited by any additional subclasses.
 */
@interface HTTPRiotRestModel : NSObject {

}

/**
 * @name Setting default request options
 * Set the default options that can be used in every request made from the model 
 * that sets them.
 * @{ 
 */

/**
 * The base url to use in every request
 */
+ (NSURL *)baseURI;

/** 
 * Set the base URL to be used in every request.
 *
 * Instead of providing a URL for every request you can set the base
 * url here.  You can also provide a path and port if you wish.  This 
 * url is prepended to the path argument of the request methods.
 *
 * @param uri The base uri used in all request
 */
+ (void)setBaseURI:(NSURL *)uri;

/**
 * Default headers sent with every request
 */
+ (NSDictionary *)headers;

/**
 * Set the default headers sent with every request.
 * @param hdrs An NSDictionary of headers.  For example you can 
 * set this up.
 *
 * @code
 * NSDictionary *hdrs = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
 * [self setHeaders:hdrs];
 * @endcode
 */
+ (void)setHeaders:(NSDictionary *)hdrs;

/**
 * Returns a dictionary containing the username and password used for basic auth.
 */
+ (NSDictionary *)basicAuth;

/**
 * Set the username and password used in requests that require basic authentication.
 *
 * The username and password privded here will be Base64 encoded and sent as an 
 * <code>Authorization</code> header.
 * @param username user name used to authenticate
 * @param password Password used to authenticate
 */
+ (void)setBasicAuthWithUsername:(NSString *)username password:(NSString *)password;

/**
 * Default params sent with every request.
 */
+ (NSDictionary *)defaultParams;

/**
 * Set the defaul params sent with every request.
 * If you need to send something with every request this is the perfect way to do it.
 * For GET request, these parameters will be appended to the query string.  For 
 * POST request these parameters are sent with the body.
 */
+ (void)setDefaultParams:(NSDictionary *)params;

/**
 * The format used to decode and encode request and responses.
 * Supported formats are JSON and XML.
 */
+ (kHTTPRiotFormat)format;

/**
 * Set the format used to decode and encode request and responses.
 */
+ (void)setFormat:(kHTTPRiotFormat)format;
//@}

/** 
 * @name Sending Requests
 * These methods allow you to send GET, POST, PUT and DELETE requetsts.
 *
 * <h3>Request Options</h3>
 * All requests can take numerous types of options passed as the second argument.
 * @li @b headers <tt>NSDictionary</tt> - The headers to send with the request
 * @li @b params <tt>NSDictionary</tt> - The query or body parameters sent with the request.
 * @li @b body <tt>NSData</tt>, <tt>NSString</tt> or <tt>NSDictionary</tt> - This option is used only during POST and PUT
 *     requests.  This option is eventually transformed into an NSData object before it is sent.
 *     If you supply the body as an NSDictionary it's turned to a query string &foo=bar&baz=boo and 
 *     then it's encoded as an NSData object.  If you supply an NSString, it's encoded as an NSData 
 *     object and sent.  
 * @{
 */
 
/**
 * Send a GET request
 * @param path The path to get.  If you haven't setup the baseURI option you'll need to provide a 
 *        full url. 
 * @param options The options for this request.
 * @param error If any errors are returned they will be stored here.
 */
+ (NSArray *)getPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
+ (NSArray *)postPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
+ (NSArray *)putPath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
+ (NSArray *)deletePath:(NSString *)path withOptions:(NSDictionary *)options error:(NSError **)error;
//@}
@end
