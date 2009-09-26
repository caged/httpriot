//
//  HRResponse.m
//  HTTPRiot
//
//  Created by Justin Palmer on 8/11/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HRResponse.h"


@implementation HRResponse
@synthesize rawResponse             = _rawResponse;
@synthesize responseBody            = _responseBody;
@synthesize statusCode              = _statusCode;
@synthesize headers                 = _headers;
@synthesize localizedFailureReason  = _localizedFailureReason;
@synthesize error                   = _error;

+ (id)responseWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data error:(NSError *)error {
    return [[[self alloc] initWithHTTPResponse:response data:data error:error] autorelease];
}

- (id)initWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data error:(NSError *)error {
   if(self = [super init]) {
       _rawResponse     = [response retain];
       _statusCode      = [_rawResponse statusCode];
       _headers         = [[_rawResponse allHeaderFields] retain];
       _responseBody    = [data retain];
       _error           = [error retain];
       
       if(_statusCode) {
           _localizedFailureReason  = [NSHTTPURLResponse localizedStringForStatusCode:_statusCode];
       }
   }
   
   return self;
}

- (void)dealloc {
    [_error release];
    [_localizedFailureReason release];
    [_responseBody release];
    [_headers release];
    [super dealloc];
}

@end
