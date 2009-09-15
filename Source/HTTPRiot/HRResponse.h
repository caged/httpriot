//
//  HRResponse.h
//  HTTPRiot
//
//  Created by Justin Palmer on 8/11/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRResponse : NSObject {
    NSInteger _statusCode;
    NSDictionary *_headers;
    id _responseBody;
}

@property (nonatomic, readonly, retain) id responseBody;
@property (nonatomic, readonly, assign) NSInteger statusCode;
@property (nonatomic, readonly, retain) NSDictionary *headers;

+ (id)responseWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data;

- (id)initWithHTTPResponse:(NSHTTPURLResponse *)response data:(id)data;
- (NSString *)localizedFailureReason;
@end
