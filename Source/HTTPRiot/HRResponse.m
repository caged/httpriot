//
//  HRResponse.m
//  HTTPRiot
//
//  Created by Justin Palmer on 8/11/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "HRResponse.h"


@implementation HRResponse
@synthesize responseBody = _responseBody;
@synthesize statusCode = _statusCode;
@synthesize headers = _headers;

- (id)initWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data {
   if(self = [super init]) {
       _statusCode = [response statusCode];
       _responseBody = [data retain];
       _headers = [[response allHeaderFields] retain];
   }
   
   return self;
}

+ (id)responseWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data {
    return [[[self alloc] initWithHTTPResponse:response data:data] autorelease];
}

- (NSString *)localizedFailureReason {
   return [NSHTTPURLResponse localizedStringForStatusCode:_statusCode];
}

- (void)dealloc {
    [_responseBody release];
    [_headers release];
    [super dealloc];
}

@end
