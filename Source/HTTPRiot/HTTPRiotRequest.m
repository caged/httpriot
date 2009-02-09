//
//  HTTPRiotRequest.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotRequest.h"
#import "NSString+URI.h"
#import "NSDictionary+URI.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "HTTPRiotFormatJSON.h"
#import "HTTPRiotFormatXML.h"

@interface HTTPRiotRequest (PrivateMethods)
- (NSMutableURLRequest *)http;
- (id)handleResponse:(NSHTTPURLResponse *)response;
- (NSArray *)formattedResults:(NSData *)data;
@end

@implementation HTTPRiotRequest

@synthesize timeout;
@synthesize httpMethod;
@synthesize path;
@synthesize options;
@synthesize fullURL;

- (void)dealloc
{
    [path release];
    [options release];
    [super dealloc];
}

- (id)initWithMethod:(kHTTPRiotMethod)method
                path:(NSString*)urlPath
             options:(NSDictionary*)requestOptions
{
    if(self = [super init])
    {
        httpMethod = method;
        path = urlPath;
        options = [requestOptions retain];
    }

    return self;
}

+ (NSArray *)requestWithMethod:(kHTTPRiotMethod)method
                        path:(NSString*)urlPath
                     options:(NSDictionary*)requestOptions
{
    NSData *body;
    id instance = [[self alloc] initWithMethod:method path:urlPath options:requestOptions];
    //NSLog(@"%@ %@%@", [method uppercaseString], site, path);
    if(instance)
    {
        NSHTTPURLResponse *response;
        NSError *error;
        body = [NSURLConnection sendSynchronousRequest:[instance http]
                                             returningResponse:&response
                                                         error:&error];
        [instance handleResponse:response];
    }
    
    id results = [instance formattedResults:body];
    [instance release];
    
    return results;
}

-(NSArray *)formattedResults:(NSData *)data
{   
    NSNumber *format = [[self options] objectForKey:@"format"];
    switch([format intValue])
    {
        case kHTTPRiotJSONFormat:
            return [HTTPRiotFormatJSON decode:data];
        break;
        case kHTTPRiotXMLFormat:
            return [HTTPRiotFormatXML decode:data];
        break;
    }
    
    [NSException raise:@"InvalidFormatException" format:@"Unsupported format.  Format must be json or xml"];
    return nil;
}

+ (NSString *)buildQueryString:(NSDictionary *)theParams
{
    NSString *query = @"";
    if(theParams)
    {
         if([theParams count] > 0)
             return [theParams toQueryString];
    }
    
    return query;
}

- (NSMutableURLRequest *)http
{
    NSMutableURLRequest *tmpHTTP = [NSMutableURLRequest requestWithURL:[self fullURL]];
    [tmpHTTP setTimeoutInterval:60.0];
    
    switch([self httpMethod])
    {
        case kHTTPRiotMethodGet: 
            [tmpHTTP setHTTPMethod:@"get"];
        break;
        // TODO: POST BODY STUFF
        case kHTTPRiotMethodPost:
            [tmpHTTP setHTTPMethod:@"post"];
        break;
    }
    
    return tmpHTTP;
}

- (NSURL *)fullURL
{
    // NSLog(@"%s options:%@", _cmd, options);
    NSURL *tmpURI = [NSURL URLWithString:path];
    NSURL *baseURI = [options objectForKey:@"baseURI"];
    
    if([tmpURI host] == nil && [baseURI host] == nil)
        [NSException raise:@"UnspecifiedHost" format:@"host wasn't provided in baseURI or path"];
    
    // NSLog(@"%s query:%@", _cmd, pathWithQuery);
    
    // If a host is provided in the path, give it precedence over the default baseURI
    // TODO: merge query params if they are specified as part of the url and also provided 
    // via the params option.
    NSString *pathWithQuery = [path stringByAppendingString:[[self class] buildQueryString:[self params]]];
    
    if([tmpURI host])
        tmpURI = [NSURL URLWithString:pathWithQuery relativeToURL:tmpURI];
    else
        tmpURI = [NSURL URLWithString:pathWithQuery relativeToURL:baseURI];

    // NSAssert([tmpURL host] != nil && [baseURI host] != nil, @"You must specify a baseURI or a host with the path");
    
    return tmpURI;
}

- (NSDictionary *)params
{
   return [options objectForKey:@"params"];
}

- (id)handleResponse:(NSHTTPURLResponse *)response
{
    unsigned int code = [response statusCode];
    NSRange okRange = NSMakeRange(200, 400);
    NSRange clientErrorRange = NSMakeRange(401, 500);
    NSRange serverErrorRange = NSMakeRange(500, 600);
    
    if(code == 300 || code == 302)
        [NSException raise:@"RedirectNotHandled" format:@"STATUS:%i Redirection not handled", code];
    else if(NSLocationInRange(code, okRange))
        return response;
    else if(code == 400)
        [NSException raise:@"BadRequest" format:@"STATUS:%i Bad request", code];
    else if(code == 401)
        [NSException raise:@"UnauthrizedAccess" format:@"STATUS:%i Unauthorized access to resource", code];
    else if(code == 403)
        [NSException raise:@"ForbiddenAccess" format:@"STATUS:%i Forbidden access to resource", code];
    else if(code == 404)
        [NSException raise:@"ResourceNotFound" format:@"STATUS:%i Unable to locate resource", code];
    else if(code == 405)
        [NSException raise:@"MethodNotAllowed" format:@"STATUS:%i Method not allowed", code];
    else if(code == 409)
        [NSException raise:@"ResourceConflict" format:@"STATUS:%i Resource conflict", code];
    else if(code == 422)
        [NSException raise:@"ResourceInvalid" format:@"STATUS:%i Invalid resource", code];
    else if(NSLocationInRange(code, clientErrorRange))
        [NSException raise:@"ClientError" format:@"STATUS:%i Unknown Client Error", code];
    else if(NSLocationInRange(code, serverErrorRange))
        [NSException raise:@"ServerError" format:@"STATUS:%i Unknown Server Error", code];
    else
        [NSException raise:@"ConnectionError" format:@"STATUS:%i Unknown status code"];

    
    return nil;
}
@end
