//
//  HRResponseDelegate.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//



@protocol HRResponseDelegate
- (void)didFailWithResponse:(NSHTTPURLResponse)response;
- (void)didFinishLoadingData:(id)data response:(NSHTTPURLResponse)response;
@end
