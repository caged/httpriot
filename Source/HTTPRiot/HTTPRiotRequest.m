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
- (NSArray *)formattedResults:(NSData *)data;
- (void)setDefaultHeadersForRequest:(NSMutableURLRequest *)request;
- (void)setAuthHeadersForRequest:(NSMutableURLRequest *)request;
- (NSMutableURLRequest *)configuredRequest;
- (id)formatterFromFormat;
- (NSURL *)composedURI;
+ (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error;
+ (NSString *)buildQueryStringFromParams:(NSDictionary *)params;
@end

static NSArray *httpMethods;

@implementation HTTPRiotRequest

@synthesize timeout;
@synthesize httpMethod;
@synthesize path;
@synthesize options;
@synthesize formatter;

+ (void)initialize
{
    if(!httpMethods)
        httpMethods = [[NSArray arrayWithObjects:@"", @"GET", @"POST", @"PUT", @"DELETE", nil] retain];
        
}

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
        [self setFormatter:[self formatterFromFormat]];
    }

    return self;
}

- (id)formatterFromFormat
{
    NSNumber *format = [[self options] objectForKey:@"format"];
    switch([format intValue])
    {
        case kHTTPRiotJSONFormat:
            return [HTTPRiotFormatJSON class];
        break;
        case kHTTPRiotXMLFormat:
            return [HTTPRiotFormatXML class];
        break;
    }
    
    [NSException raise:@"InvalidFormatException" format:@"Unsupported format.  Format must be json or xml"];     
    return nil;  
}

- (void)setDefaultHeadersForRequest:(NSMutableURLRequest *)request
{
    NSDictionary *headers = [[self options] valueForKey:@"headers"];

    [request setValue:[[self formatter] mimeType] forHTTPHeaderField:@"Content-Type"];  
    [request addValue:[[self formatter] mimeType] forHTTPHeaderField:@"Accept"];

    if(headers)
        [request setAllHTTPHeaderFields:headers];
}

- (void)setAuthHeadersForRequest:(NSMutableURLRequest *)request
{
    NSDictionary *authDict = [options valueForKey:@"basicAuth"];
    NSString *username = [authDict valueForKey:@"username"];
    NSString *password = [authDict valueForKey:@"password"];

    if(username || password)
    {
        username = [username stringByPreparingForURL];
        password = [password stringByPreparingForURL];
        
        NSString *userPass = [NSString stringWithFormat:@"%@:%@", username, password];
        NSData *b64 = [userPass dataUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedUserPass = [b64 base64Encoding];
        NSString *basicHeader = [NSString stringWithFormat:@"Basic %@", encodedUserPass];
        [request setValue:basicHeader forHTTPHeaderField:@"Authorization"];
    }
    
}

- (NSMutableURLRequest *)configuredRequest
{
    kHTTPRiotMethod method = [self httpMethod];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30.0];
    [self setDefaultHeadersForRequest:request];
    [self setAuthHeadersForRequest:request];
    
    NSURL *composedURL = [self composedURI];
    NSDictionary *params = [[self options] valueForKey:@"params"];
    NSString *queryString = [[self class] buildQueryStringFromParams:params];
    
    if(method == kHTTPRiotMethodGet)
    {
        [request setHTTPMethod:@"GET"];
        NSString *urlString = [[composedURL absoluteString] stringByAppendingString:queryString];
        NSURL *url = [NSURL URLWithString:urlString];
        [request setURL:url];
    } 
    else if(method == kHTTPRiotMethodPost || kHTTPRiotMethodPost)
    {
        NSString *json = [formatter encode:params];
        [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setURL:composedURL];
        
        if(method == kHTTPRiotMethodPost)
            [request setHTTPMethod:@"POST"];
        else
            [request setHTTPMethod:@"PUT"];
            
    }
    
    return request;
}

- (NSURL *)composedURI
{
    NSURL *tmpURI = [NSURL URLWithString:path];
    NSURL *baseURI = [options objectForKey:@"baseURI"];
    
    if([tmpURI host] == nil && [baseURI host] == nil)
        [NSException raise:@"UnspecifiedHost" format:@"host wasn't provided in baseURI or path"];
    
    if([tmpURI host])
        tmpURI = [NSURL URLWithString:path relativeToURL:tmpURI];
    else
        tmpURI = [NSURL URLWithString:path relativeToURL:baseURI];

    
    return tmpURI;
}

#pragma mark - Class Methods
+ (id)requestWithMethod:(kHTTPRiotMethod)method
                        path:(NSString*)urlPath
                     options:(NSDictionary*)requestOptions
                     error:(NSError **)error
{
    NSError *responseError = nil;
    id results = nil;
    NSData *body;
    id instance = [[[self alloc] initWithMethod:method path:urlPath options:requestOptions] autorelease];
    if(instance)
    {
        NSHTTPURLResponse *response;
        NSMutableURLRequest *request = [instance configuredRequest];
        NSError *connectionError = nil;
        body = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&connectionError];
        
        if(connectionError)
        {
            if(error) *error = connectionError;
            return results;
        }
        
        [self handleResponse:response error:&responseError];
        
        //TODO Should we attempt to parse the response even if we have an error
        if(responseError)
        {
            if(error) *error = responseError;
            return results;
        } 

        if([body length] > 0)
            results = [[instance formatter] decode:body];
    }
    return results;
}

+ (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error
{
    NSInteger code = [response statusCode];
    NSUInteger ucode = [[NSNumber numberWithInt:code] unsignedIntValue];
    NSRange okRange = NSMakeRange(200, 200);
    NSRange clientErrorRange = NSMakeRange(401, 99);
    NSRange serverErrorRange = NSMakeRange(500, 100);
    
    NSDictionary *headers = [response allHeaderFields];
    NSString *errorReason = [NSString stringWithFormat:@"%d Error: ", code];
    NSString *errorDescription;
    
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
    } else if(NSLocationInRange(ucode, clientErrorRange)) {
        errorReason = [errorReason stringByAppendingString:@"ClientError"];
        errorDescription = @"Unknown Client Error";
    } else if(NSLocationInRange(ucode, serverErrorRange)) {
        errorReason = [errorReason stringByAppendingString:@"ServerError"];
        errorDescription = @"Unknown Server Error";
    } else {
        errorReason = [errorReason stringByAppendingString:@"ConnectionError"];
        errorDescription = @"Unknown status code";
    }
    
    NSDictionary *userInfo = [[[NSDictionary dictionaryWithObjectsAndKeys:
                               errorReason, NSLocalizedFailureReasonErrorKey,
                               errorDescription, NSLocalizedDescriptionKey, 
                               headers, @"headers", nil] retain] autorelease];
    *error = [NSError errorWithDomain:HTTPRiotErrorDomain code:code userInfo:userInfo];
    return nil;
}

+ (NSString *)buildQueryStringFromParams:(NSDictionary *)theParams
{
    if(theParams)
    {
         if([theParams count] > 0)
             return [theParams toQueryString];
    }
    
    return @"";
}
@end
