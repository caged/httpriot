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
    kHTTPRiotMethod httpMethod;
    NSString *path;
    NSDictionary *options;
    NSArray *methodStrings;
    id formatter;
}

@property (nonatomic, assign) CGFloat timeout;
@property (nonatomic, assign) kHTTPRiotMethod httpMethod;
@property (nonatomic, readonly, copy) NSString *path;
@property (nonatomic, readonly, retain) NSDictionary *options;
@property (nonatomic, readonly, retain) id formatter;

+ (id)requestWithMethod:(kHTTPRiotMethod)method
                         path:(NSString*)urlPath
                      options:(NSDictionary*)requestOptions
                        error:(NSError **)error;
@end
