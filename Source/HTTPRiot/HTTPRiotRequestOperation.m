//
//  HTTPRiotRequestOperation.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotRequestOperation.h"
#import "NSString+URI.h"
#import "NSDictionary+URI.h"
#import "NSData+Base64.h"
#import "HTTPRiotFormatJSON.h"
#import "HTTPRiotFormatXML.h"

static NSOperationQueue *HROperationQueue;

@interface HTTPRiotRequestOperation (PrivateMethods)
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

@implementation HTTPRiotRequestOperation

@synthesize timeout;
@synthesize httpMethod;
@synthesize path;
@synthesize options;
@synthesize formatter;


- (void)dealloc
{
    [obj release];
    [path release];
    [options release];
    [formatter release];
    [super dealloc];
}

- (id)initWithMethod:(kHTTPRiotMethod)method
                path:(NSString*)urlPath
             options:(NSDictionary*)requestOptions
             target:(id)tgt
             selector:(SEL)sel
             object:(id)aobj
{
    if(self = [super init])
    {
        httpMethod = method;
        path = [urlPath copy];
        options = [requestOptions retain];
        formatter = [[self formatterFromFormat] retain];
        target = tgt;
        didEndSelector = sel;
        
        if(aobj && [aobj isMemberOfClass:[NSString class]])
            obj = [aobj copy];
        else
            obj = [aobj retain];
        
        if(!HROperationQueue)
            HROperationQueue = [[NSOperationQueue alloc] init];
    }

    return self;
}

- (id)formatterFromFormat
{
    NSNumber *format = [[self options] objectForKey:@"format"];
    id theFormatter = nil;
    switch([format intValue])
    {
        case kHTTPRiotJSONFormat:
            theFormatter = [HTTPRiotFormatJSON class];
        break;
        case kHTTPRiotXMLFormat:
            theFormatter = [HTTPRiotFormatXML class];
        break;
        default:
            theFormatter = [HTTPRiotFormatJSON class];
        break;   
    }
    
    
    NSString *errorMessage = [NSString stringWithFormat:@"Invalid Formatter %@", NSStringFromClass(theFormatter)];
    NSAssert([theFormatter conformsToProtocol:@protocol(HTTPRiotFormatterProtocol)], errorMessage); 
    
    return theFormatter;
}

- (void)setDefaultHeadersForRequest:(NSMutableURLRequest *)request
{
    NSDictionary *headers = [[self options] valueForKey:@"headers"];
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
    id body = [[self options] valueForKey:@"body"];
    NSString *queryString = [[self class] buildQueryStringFromParams:params];
    
    if(method == kHTTPRiotMethodGet || method == kHTTPRiotMethodDelete)
    {
        NSString *urlString = [[composedURL absoluteString] stringByAppendingString:queryString];
        NSLog(@"URL:%@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        [request setURL:url];
        [request setValue:[[self formatter] mimeType] forHTTPHeaderField:@"Content-Type"];  
        [request addValue:[[self formatter] mimeType] forHTTPHeaderField:@"Accept"];
        
        if(method == kHTTPRiotMethodGet)
            [request setHTTPMethod:@"GET"];
        else
            [request setHTTPMethod:@"DELETE"];
    } 
    else if(method == kHTTPRiotMethodPost || kHTTPRiotMethodPost)
    {
        NSData *bodyData = nil;
        if(params && [params isKindOfClass:[NSDictionary class]] && body == nil)
        {   
            bodyData = [[params toQueryString] dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:bodyData];
        }
        else
        {            
            if([body isKindOfClass:[NSDictionary class]])
                bodyData = [[body toQueryString] dataUsingEncoding:NSUTF8StringEncoding];
            else if([body isKindOfClass:[NSString class]])
                bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
            else if([body isKindOfClass:[NSString class]])
                bodyData = body;
            else
                [NSException exceptionWithName:@"InvalidBodyData"
                                        reason:@"The body must be an NSDictionary, NSString, or NSData"
                                      userInfo:nil];
            
            [request setHTTPBody:bodyData];
        }
        
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
        return tmpURI;
        
    return [NSURL URLWithString:[[baseURI absoluteString] stringByAppendingPathComponent:path]];
}

- (void)main
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    NSError *error = nil, *responseError = nil;
    id results = nil;
    NSData *body;
    NSDictionary *info;
    
    NSMutableURLRequest *request = [self configuredRequest];
    NSError *connectionError = nil;
    NSHTTPURLResponse *response;
    body = [NSURLConnection sendSynchronousRequest:request
                                 returningResponse:&response
                                             error:&connectionError];
    
    if(connectionError)
    {        
        error = connectionError;
        if([target respondsToSelector:didEndSelector])      
        {
            info = [[[NSDictionary alloc] initWithObjectsAndKeys:error, @"error", nil] autorelease];            
            [target performSelectorOnMainThread:didEndSelector withObject:info waitUntilDone:YES];
            
            [pool drain];
            return;
        }
    }
    
    [[self class] handleResponse:response error:&responseError];
    
    if(responseError && connectionError == nil)
    {
        error = responseError;
    } 

    if([body length] > 0)
    {
        results = [[self formatter] decode:body];        
    }
    
    if([target respondsToSelector:didEndSelector])
    {   
        info = [NSDictionary dictionaryWithObjectsAndKeys:results, @"results", 
                            obj, @"object",
                            response, @"response", 
                            error, @"error", 
                            nil];
        
        [target performSelectorOnMainThread:didEndSelector withObject:info waitUntilDone:YES];
    }
    
    [pool drain];
}

#pragma mark - Class Methods
+ (NSOperation *)requestWithMethod:(kHTTPRiotMethod)method
                        path:(NSString*)urlPath
                     options:(NSDictionary*)requestOptions
                     target:(id)target
                     selector:(SEL)sel
                     object:(id)obj
{    
    id instance = [[self alloc] initWithMethod:method
                                          path:urlPath
                                       options:requestOptions
                                        target:target
                                      selector:sel
                                      object:obj];
    
    [HROperationQueue addOperation:instance];
    return [instance autorelease];
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
    
    if(error != nil)
    {
        NSDictionary *userInfo = [[[NSDictionary dictionaryWithObjectsAndKeys:
                                   errorReason, NSLocalizedFailureReasonErrorKey,
                                   errorDescription, NSLocalizedDescriptionKey, 
                                   headers, @"headers", 
                                   [[response URL] absoluteString], @"url", nil] retain] autorelease];
        *error = [NSError errorWithDomain:HTTPRiotErrorDomain code:code userInfo:userInfo];
    }

    return nil;
}

+ (NSString *)buildQueryStringFromParams:(NSDictionary *)theParams
{
    if(theParams)
    {
         if([theParams count] > 0)
             return [NSString stringWithFormat:@"?%@", [theParams toQueryString]];
    }
    
    return @"";
}
@end
