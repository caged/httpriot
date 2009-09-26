/**
 * @file HRResponseDelegate.h Protocol for the response delegate methods.
 */
 
//
//  HRResponseDelegate.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

@class HRResponse;

/**
 * @protocol HRResponseDelegate
 *
 * Implementing the HRResponseDelegate protocol allows you to handle requests.  
 */
@protocol HRResponseDelegate <NSObject>
@optional
/**
 * Called when the resource was succeffully fetched and encoded
 *
 * @param connection The connection object for the current request
 * @param resource The converted objc representation of the response data returned by the server.
 * @param object Any custom object you passed in while making the request.
 */
- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object;

/**
 * Called when the connection fails in situations where the server is not available, etc.
 *
 * @param connection The connection object for the current request
 * @param error The error returned by the connection.
 * @param object Any custom object you passed in while making the request.
 */
- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object;

/**
 * Called when the connection receieves any type of response
 *
 * @param connection The connection object for the current request
 * @param response The response object returned by the server.
 * @param object Any custom object you passed in while making the request.
 */
- (void)restConnection:(NSURLConnection *)connection didReceiveResponse:(HRResponse *)response object:(id)object;

/**
 * Called when the connection receieves a statusCode that isn't a success code.
 *
 * @param connection The connection object for the current request
 * @param error The error returned by the connection.
 * @param response The response object returned by the server.
 * @param object Any custom object you passed in while making the request.
 */
- (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(HRResponse *)response object:(id)object;

/**
 * Called when the HRFormatter recieved an error parsing the response data.
 *
 * @param connection The connection object for the current request
 * @param error The parser error returned by the formatter.
 * @param response The response from the server.
 * @param object Any custom object you passed in while making the request.
 */
- (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error response:(HRResponse *)response object:(id)object;
@end
