//
//  HRResponseDelegate.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//



@protocol HRResponseDelegate <NSObject>
@optional
- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)obj;
- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)obj;
- (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)obj;
@end
