//
//  HRRequestOperation.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HRRequestOperation.h"
#import "HRFormatJSON.h"
#import "HRFormatXML.h"
#import "NSObject+InvocationUtils.h"
#import "NSString+URI.h"
#import "NSDictionary+URI.h"
#import "NSData+Base64.h"

static NSOperationQueue *HROperationQueue;

@interface HRRequestOperation (PrivateMethods)
- (NSMutableURLRequest *)http;
- (NSArray *)formattedResults:(NSData *)data;
- (void)setDefaultHeadersForRequest:(NSMutableURLRequest *)request;
- (void)setAuthHeadersForRequest:(NSMutableURLRequest *)request;
- (NSMutableURLRequest *)configuredRequest;
- (id)formatterFromFormat;
- (NSURL *)composedURL;
+ (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error;
+ (NSString *)buildQueryStringFromParams:(NSDictionary *)params;
- (void)finish;
@end

@implementation HRRequestOperation
@synthesize timeout         = _timeout;
@synthesize requestMethod   = _requestMethod;
@synthesize path            = _path;
@synthesize options         = _options;
@synthesize formatter       = _formatter;
@synthesize delegate        = _delegate;

- (void)dealloc {
    [_path release];
    [_options release];
    [_formatter release];
    [super dealloc];
}

- (id)initWithMethod:(HRRequestMethod)method path:(NSString*)urlPath options:(NSDictionary*)opts object:(id)obj {
                 
    if(self = [super init]) {
        _isExecuting    = NO;
        _isFinished     = NO;
        _requestMethod  = method;
        _path           = [urlPath copy];
        _options        = [opts retain];
        _object         = obj;
        _delegate       = [opts valueForKey:@"delegate"];
        _formatter      = [[self formatterFromFormat] retain];
        
        if(!HROperationQueue)
            HROperationQueue = [[NSOperationQueue alloc] init];
    }

    return self;
}

#pragma mark - Concurrent NSOperation Methods
- (void)start {
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURLRequest *request = [self configuredRequest];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if(_connection) {
        _responseData = [[NSMutableData alloc] init];        
    } else {
        [self finish];
    }    
}

- (void)finish {
    [_connection release];
    _connection = nil;
    
    [_responseData release];
    _responseData = nil;

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    _isExecuting = NO;
    _isFinished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting {
   return _isExecuting;
}

- (BOOL)isFinished {
   return _isFinished;
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - NSURLConnection delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSError *error = nil;
    [[self class] handleResponse:(NSHTTPURLResponse *)response error:&error];
    
    if(error) {
        if([_delegate respondsToSelector:@selector(restConnection:didReceiveError:response:object:)]) {
            [_delegate performSelectorOnMainThread:@selector(restConnection:didReceiveError:response:object:) withObjects:connection, error, response, _object, nil];
            [connection cancel];
            [self finish];
        }
    }
    
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(restConnection:didFailWithError:object:)]) {        
        [_delegate performSelectorOnMainThread:@selector(restConnection:didFailWithError:object:) withObjects:connection, error, _object, nil];
    }
    
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id results;
    NSError *parseError = nil;
    
    if([_responseData length] > 0) {
        results = [[self formatter] decode:_responseData error:&parseError];
        
        if(parseError) {
            NSString *rawString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            if([_delegate respondsToSelector:@selector(restConnection:didReceiveParseError:responseBody:)]) {
                [_delegate performSelectorOnMainThread:@selector(restConnection:didReceiveParseError:responseBody:) withObjects:connection, parseError, rawString, nil];
                [rawString release];
                
                return [self finish];
            }
        }
    }
    
    if([_delegate respondsToSelector:@selector(restConnection:didFinishReturningResource:object:)]) {
        [_delegate performSelectorOnMainThread:@selector(restConnection:didFinishReturningResource:object:) withObjects:connection, results, _object, nil];
    }
        
    [self finish];
}

#pragma mark - Configuration
- (void)setDefaultHeadersForRequest:(NSMutableURLRequest *)request {
    NSDictionary *headers = [[self options] valueForKey:@"headers"];
    if(headers)
        [request setAllHTTPHeaderFields:headers];
}

- (void)setAuthHeadersForRequest:(NSMutableURLRequest *)request {
    NSDictionary *authDict = [_options valueForKey:@"basicAuth"];
    NSString *username = [authDict valueForKey:@"username"];
    NSString *password = [authDict valueForKey:@"password"];

    if(username || password) {
        username = [username stringByPreparingForURL];
        password = [password stringByPreparingForURL];
        
        NSString *userPass = [NSString stringWithFormat:@"%@:%@", username, password];
        NSData *b64 = [userPass dataUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedUserPass = [b64 base64Encoding];
        NSString *basicHeader = [NSString stringWithFormat:@"Basic %@", encodedUserPass];
        [request setValue:basicHeader forHTTPHeaderField:@"Authorization"];
    }
}

- (NSMutableURLRequest *)configuredRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30.0];
    [self setDefaultHeadersForRequest:request];
    [self setAuthHeadersForRequest:request];
    
    NSURL *composedURL = [self composedURL];
    NSDictionary *params = [[self options] valueForKey:@"params"];
    id body = [[self options] valueForKey:@"body"];
    NSString *queryString = [[self class] buildQueryStringFromParams:params];
    
    if(_requestMethod == HRRequestMethodGet || _requestMethod == HRRequestMethodDelete) {
        NSString *urlString = [[composedURL absoluteString] stringByAppendingString:queryString];
        NSLog(@"URL:%@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        [request setURL:url];
        [request setValue:[[self formatter] mimeType] forHTTPHeaderField:@"Content-Type"];  
        [request addValue:[[self formatter] mimeType] forHTTPHeaderField:@"Accept"];
        
        if(_requestMethod == HRRequestMethodGet)
            [request setHTTPMethod:@"GET"];
        else
            [request setHTTPMethod:@"DELETE"];
            
    } else if(_requestMethod == HRRequestMethodPost || _requestMethod == HRRequestMethodPut) {
        
        NSData *bodyData = nil;
        
        if(params && [params isKindOfClass:[NSDictionary class]] && body == nil) {   
            bodyData = [[params toQueryString] dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:bodyData];
        } else {            
            if([body isKindOfClass:[NSDictionary class]])
                bodyData = [[body toQueryString] dataUsingEncoding:NSUTF8StringEncoding];
            else if([body isKindOfClass:[NSString class]])
                bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
            else if([body isKindOfClass:[NSData class]])
                bodyData = body;
            else
                [NSException exceptionWithName:@"InvalidBodyData"
                                        reason:@"The body must be an NSDictionary, NSString, or NSData"
                                      userInfo:nil];
            
            [request setHTTPBody:bodyData];
        }
        
        [request setURL:composedURL];
        
        if(_requestMethod == HRRequestMethodPost)
            [request setHTTPMethod:@"POST"];
        else
            [request setHTTPMethod:@"PUT"];
            
    }
    
    return request;
}

- (NSURL *)composedURL {
    NSURL *tmpURI = [NSURL URLWithString:_path];
    NSURL *baseURL = [_options objectForKey:@"baseURL"];

    if([tmpURI host] == nil && [baseURL host] == nil)
        [NSException raise:@"UnspecifiedHost" format:@"host wasn't provided in baseURL or path"];
    
    if([tmpURI host])
        return tmpURI;
        
    return [NSURL URLWithString:[[baseURL absoluteString] stringByAppendingPathComponent:_path]];
}

- (id)formatterFromFormat {
    NSNumber *format = [[self options] objectForKey:@"format"];
    id theFormatter = nil;
    
    switch([format intValue]) {
        case HRDataFormatJSON:
            theFormatter = [HRFormatJSON class];
        break;
        case HRDataFormatXML:
            theFormatter = [HRFormatXML class];
        break;
        default:
            theFormatter = [HRFormatJSON class];
        break;   
    }
    
    NSString *errorMessage = [NSString stringWithFormat:@"Invalid Formatter %@", NSStringFromClass(theFormatter)];
    NSAssert([theFormatter conformsToProtocol:@protocol(HRFormatterProtocol)], errorMessage); 
    
    return theFormatter;
}


#pragma mark - Class Methods
+ (HRRequestOperation *)requestWithMethod:(HRRequestMethod)method path:(NSString*)urlPath options:(NSDictionary*)requestOptions object:(id)obj {
                             
    id operation = [[self alloc] initWithMethod:method path:urlPath options:requestOptions object:obj];
    [HROperationQueue addOperation:operation];
    return [operation autorelease];
}

+ (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error {
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
    
    if(error != nil) {
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
    if(theParams) {
         if([theParams count] > 0)
             return [NSString stringWithFormat:@"?%@", [theParams toQueryString]];
    }
    
    return @"";
}
@end
