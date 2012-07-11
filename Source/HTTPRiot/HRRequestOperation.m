//
//  HRRequestOperation.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HRRequestOperation.h"
#import "HRFormatterFactory.h"
#import "NSObject+InvocationUtils.h"
#import "NSString+EscapingUtils.h"
#import "NSDictionary+ParamUtils.h"
#import "HRBase64.h"
#import "HROperationQueue.h"

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
    [_object release];
    [super dealloc];
}

- (id)initWithMethod:(HRRequestMethod)method path:(NSString*)urlPath options:(NSDictionary*)opts object:(id)obj {
                 
    if(self = [super init]) {
        _isExecuting    = NO;
        _isFinished     = NO;
        _isCancelled    = NO;
        _requestMethod  = method;
        _path           = [urlPath copy];
        _options        = [opts retain];
        _object         = [obj retain];
        _timeout        = 30.0;
        _delegate       = [[opts valueForKey:kHRClassAttributesDelegateKey] nonretainedObjectValue];
        _formatter      = [[self formatterFromFormat] retain];
    }

    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Concurrent NSOperation Methods
- (void)start {
    // Snow Leopard Fix. See http://www.dribin.org/dave/blog/archives/2009/09/13/snowy_concurrent_operations/
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURLRequest *request = [self configuredRequest];
    HRLOG(@"FETCHING:%@ \nHEADERS:%@", [[request URL] absoluteString], [request allHTTPHeaderFields]);
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if(_connection) {
        _responseData = [[NSMutableData alloc] init];        
    } else {
        [self finish];
    }    
}

- (void)finish {
    HRLOG(@"Operation Finished. Releasing...");
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

- (void)cancel {
    HRLOG(@"SHOULD CANCEL");
    [self willChangeValueForKey:@"isCancelled"];
    
    [_connection cancel];    
    _isCancelled = YES;
    
    [self didChangeValueForKey:@"isCancelled"];
    
    [self finish];
}

- (BOOL)isExecuting {
   return _isExecuting;
}

- (BOOL)isFinished {
   return _isFinished;
}

- (BOOL)isCancelled {
   return _isCancelled;
}

- (BOOL)isConcurrent {
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSURLConnection delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {    
    HRLOG(@"Server responded with:%i, %@", [response statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]);
    
    if ([_delegate respondsToSelector:@selector(restConnection:didReceiveResponse:object:)]) {
        [_delegate performSelectorOnMainThread:@selector(restConnection:didReceiveResponse:object:) withObjects:connection, response, _object, nil];
    }
    
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
    HRLOG(@"Connection failed: %@", [error localizedDescription]);
    if([_delegate respondsToSelector:@selector(restConnection:didFailWithError:object:)]) {        
        [_delegate performSelectorOnMainThread:@selector(restConnection:didFailWithError:object:) withObjects:connection, error, _object, nil];
    }
    
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {    
    id results = [NSNull null];
    NSError *parseError = nil;
    if([_responseData length] > 0) {
        results = [[self formatter] decode:_responseData error:&parseError];
                
        if(parseError) {
            NSString *rawString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            if([_delegate respondsToSelector:@selector(restConnection:didReceiveParseError:responseBody:object:)]) {
                [_delegate performSelectorOnMainThread:@selector(restConnection:didReceiveParseError:responseBody:object:) withObjects:connection, parseError, rawString, _object, nil];                
            }
            
            [rawString release];
            [self finish];
            
            return;
        }  
    }

    if([_delegate respondsToSelector:@selector(restConnection:didReturnResource:object:)]) {        
        [_delegate performSelectorOnMainThread:@selector(restConnection:didReturnResource:object:) withObjects:connection, results, _object, nil];
    }
        
    [self finish];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Configuration

- (void)setDefaultHeadersForRequest:(NSMutableURLRequest *)request {
    NSDictionary *headers = [[self options] valueForKey:kHRClassAttributesHeadersKey];
    [request setValue:[[self formatter] mimeType] forHTTPHeaderField:@"Content-Type"];  
    [request addValue:[[self formatter] mimeType] forHTTPHeaderField:@"Accept"];
    if(headers) {
        for(NSString *header in headers) {
            NSString *value = [headers valueForKey:header];
            if([header isEqualToString:@"Accept"]) {
                [request addValue:value forHTTPHeaderField:header];
            } else {
                [request setValue:value forHTTPHeaderField:header];
            }
        }        
    }
}

- (void)setAuthHeadersForRequest:(NSMutableURLRequest *)request {
    NSDictionary *authDict = [_options valueForKey:kHRClassAttributesBasicAuthKey];
    NSString *username = [authDict valueForKey:kHRClassAttributesUsernameKey];
    NSString *password = [authDict valueForKey:kHRClassAttributesPasswordKey];
    
    if(username || password) {
        NSString *userPass = [NSString stringWithFormat:@"%@:%@", username, password];
        NSData   *upData = [userPass dataUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedUserPass = [HRBase64 encode:upData];
        NSString *basicHeader = [NSString stringWithFormat:@"Basic %@", encodedUserPass];
        [request setValue:basicHeader forHTTPHeaderField:@"Authorization"];
    }
}

- (NSMutableURLRequest *)configuredRequest {
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:_timeout];
    [request setHTTPShouldHandleCookies:YES];
    [self setDefaultHeadersForRequest:request];
    [self setAuthHeadersForRequest:request];
    
    NSURL *composedURL = [self composedURL];
    NSDictionary *params = [[self options] valueForKey:kHRClassAttributesParamsKey];
    id body = [[self options] valueForKey:kHRClassAttributesBodyKey];
    NSString *queryString = [[self class] buildQueryStringFromParams:params];
    
    if(_requestMethod == HRRequestMethodGet || _requestMethod == HRRequestMethodDelete) {
        NSString *urlString = [[composedURL absoluteString] stringByAppendingString:queryString];
        NSURL *url = [NSURL URLWithString:urlString];
        [request setURL:url];
        
        if(_requestMethod == HRRequestMethodGet) {
            [request setHTTPMethod:@"GET"];
        } else {
            [request setHTTPMethod:@"DELETE"];
        }
            
    } else if(_requestMethod == HRRequestMethodPost || _requestMethod == HRRequestMethodPut) {
        
        NSData *bodyData = nil;   
        if([body isKindOfClass:[NSDictionary class]]) {
            bodyData = [[body toQueryString] dataUsingEncoding:NSUTF8StringEncoding];
        } else if([body isKindOfClass:[NSString class]]) {
            bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        } else if([body isKindOfClass:[NSData class]]) {
            bodyData = body;
        } else {
            [NSException exceptionWithName:@"InvalidBodyData"
                                    reason:@"The body must be an NSDictionary, NSString, or NSData"
                                  userInfo:nil];
        }
            
        [request setHTTPBody:bodyData];
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
    NSURL *baseURL = [_options objectForKey:kHRClassAttributesBaseURLKey];

    if([tmpURI host] == nil && [baseURL host] == nil)
        [NSException raise:@"UnspecifiedHost" format:@"host wasn't provided in baseURL or path"];
    
    if([tmpURI host])
        return tmpURI;
        
    return [NSURL URLWithString:[[baseURL absoluteString] stringByAppendingPathComponent:_path]];
}

- (id)formatterFromFormat {
    NSNumber *format = [[self options] objectForKey:kHRClassAttributesFormatKey];
    return [HRFormatterFactory formatterForFormat:[format integerValue]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
+ (HRRequestOperation *)requestWithMethod:(HRRequestMethod)method path:(NSString*)urlPath options:(NSDictionary*)requestOptions object:(id)obj {
    id operation = [[self alloc] initWithMethod:method path:urlPath options:requestOptions object:obj];
    [[HROperationQueue sharedOperationQueue] addOperation:operation];
    return [operation autorelease];
}

+ (id)handleResponse:(NSHTTPURLResponse *)response error:(NSError **)error {
    NSInteger code = [response statusCode];
    NSUInteger ucode = [[NSNumber numberWithInt:code] unsignedIntValue];
    NSRange okRange = NSMakeRange(200, 201);
    
    if(NSLocationInRange(ucode, okRange)) {
        return response;
    }

    if(error != nil) {
        NSDictionary *headers = [response allHeaderFields];
        NSString *errorReason = [NSString stringWithFormat:@"%d Error: ", code];
        NSString *errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:code];
        NSDictionary *userInfo = [[[NSDictionary dictionaryWithObjectsAndKeys:
                                   errorReason, NSLocalizedFailureReasonErrorKey,
                                   errorDescription, NSLocalizedDescriptionKey, 
                                   headers, kHRClassAttributesHeadersKey, 
                                   [[response URL] absoluteString], @"url", nil] retain] autorelease];
        *error = [NSError errorWithDomain:HTTPRiotErrorDomain code:code userInfo:userInfo];
    }

    return nil;
}

+ (NSString *)buildQueryStringFromParams:(NSDictionary *)theParams {
    if(theParams) {
        if([theParams count] > 0)
            return [NSString stringWithFormat:@"?%@", [theParams toQueryString]];
    }
    
    return @"";
}
@end
