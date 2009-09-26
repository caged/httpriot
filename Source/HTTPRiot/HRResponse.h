//
//  HRResponse.h
//  HTTPRiot
//
//  Created by Justin Palmer on 8/11/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRResponse : NSObject {
    NSHTTPURLResponse *_rawResponse;
    NSInteger _statusCode;
    NSDictionary *_headers;
    id _responseBody;
    NSString *_localizedFailureReason;
    NSError  *_error;
}

@property (nonatomic, readonly, retain) NSHTTPURLResponse *rawResponse;
@property (nonatomic, readonly, retain) id responseBody;
@property (nonatomic, readonly, assign) NSInteger statusCode;
@property (nonatomic, readonly, retain) NSDictionary *headers;
@property (nonatomic, readonly, copy) NSString *localizedFailureReason;
@property (nonatomic, readonly, retain) NSError *error;

+ (id)responseWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data error:(NSError *)error;
- (id)initWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data error:(NSError *)error;
@end
