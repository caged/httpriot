//
//  HTTPRiotRequest.h
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HTTPRiotConstants.h"

@interface HTTPRiotRequest : NSObject {
    CGFloat timeout;
    NSURL *fullURL;
    NSString *path;
    NSDictionary *options;
    
    kHTTPRiotMethod httpMethod;
}

@property (nonatomic) CGFloat timeout;
@property (nonatomic, readonly) kHTTPRiotMethod httpMethod;
@property (nonatomic, readonly, copy) NSString *path;
@property (nonatomic, readonly, retain) NSURL *fullURL;
@property (nonatomic, readonly, retain) NSDictionary *options;

+ (NSData*)requestWithMethod:(kHTTPRiotMethod)method path:(NSString*)urlPath options:(NSDictionary*)requestOptions;
- (NSDictionary *)params;
@end
