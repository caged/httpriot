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
- (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error;
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
                     error:(NSError **)error
{
    NSArray *results = [NSArray array];
    NSData *body;
    id instance = [[self alloc] initWithMethod:method path:urlPath options:requestOptions];
    //NSLog(@"%@ %@%@", [method uppercaseString], site, path);
    if(instance)
    {
        NSHTTPURLResponse *response;
        body = [NSURLConnection sendSynchronousRequest:[instance http]
                                             returningResponse:&response
                                                         error:nil];
        [instance handleResponse:response error:error];
        results = [instance formattedResults:body];
        [instance release];
    }
    
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
            [tmpHTTP setHTTPMethod:@"GET"];
        break;
        // TODO: POST BODY STUFF
        case kHTTPRiotMethodPost:
            [tmpHTTP setHTTPMethod:@"POST"];
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

- (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error
{
    NSInteger code = [response statusCode];
    NSUInteger ucode = [[NSNumber numberWithInt:code] unsignedIntValue];
    NSRange okRange = NSMakeRange(200, 200);
    NSRange clientErrorRange = NSMakeRange(401, 99);
    NSRange serverErrorRange = NSMakeRange(500, 100);
    
    NSString *errorReason = [NSString stringWithFormat:@"%d Error: ", code];
    NSString *errorDescription;
    
    NSLog(@"%s CODE:%i, %i", _cmd, code, ucode);
    if(code == 300 || code == 302) {
        errorReason = [errorReason stringByAppendingString:@"RedirectNotHandled"];
        errorDescription = @"Redirection not handled";
    } else if(NSLocationInRange(ucode, okRange)) {
        return response;
    } else if(code == 400) {
        errorReason = [errorReason stringByAppendingString:@"BadRequest"];
        errorDescription = @"Bad request";
    } else if(code == 401) {
        errorReason = [errorReason stringByAppendingString:@"UnauthrizedAccess"];
        errorDescription = @"Unauthorized access to resource";
    } else if(code == 403) {
        errorReason = [errorReason stringByAppendingString:@"ForbiddenAccess"];
        errorDescription = @"Forbidden access to resource";
    } else if(code == 404) {
        errorReason = [errorReason stringByAppendingString:@"ResourceNotFound"];
        errorDescription = @"Unable to locate resource";
    } else if(code == 405) {
        errorReason = [errorReason stringByAppendingString:@"MethodNotAllowed"];
        errorDescription = @"Method not allowed";
    } else if(code == 409) {
        errorReason = [errorReason stringByAppendingString:@"ResourceConflict"];
        errorDescription = @"Resource conflict";
    } else if(code == 422) {
        errorReason = [errorReason stringByAppendingString:@"ResourceInvalid"];
        errorDescription = @"Invalid resource";
    } else if(NSLocationInRange(code, clientErrorRange)) {
        errorReason = [errorReason stringByAppendingString:@"ClientError"];
        errorDescription = @"Unknown Client Error";
    } else if(NSLocationInRange(code, serverErrorRange)) {
        errorReason = [errorReason stringByAppendingString:@"ServerError"];
        errorDescription = @"Unknown Server Error";
    } else {
        errorReason = [errorReason stringByAppendingString:@"ConnectionError"];
        errorDescription = @"Unknown status code";
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                errorReason, NSLocalizedFailureReasonErrorKey,
                                errorDescription, NSLocalizedDescriptionKey, nil];
    *error = [NSError errorWithDomain:HTTPRiotErrorDomain code:code userInfo:userInfo];
    return nil;
}
@end
