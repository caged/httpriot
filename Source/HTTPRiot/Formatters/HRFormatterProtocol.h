//
//  HRFormatterProtocol.h
//  HTTPRiot
//
//  Created by Justin Palmer on 2/8/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol HRFormatterProtocol 
+ (NSString *)extension;
+ (NSString *)mimeType;
+ (id)decode:(NSData *)data error:(NSError **)error;
+ (NSString *)encode:(id)data error:(NSError **)error;
@end
