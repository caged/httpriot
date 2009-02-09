//
//  HTTPRiotFormatterProtocol.h
//  HTTPRiot
//
//  Created by Justin Palmer on 2/8/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//


@protocol HTTPRiotFormatterProtocol 
+ (NSString *)extension;
+ (NSString *)mimeType;
+ (id)decode:(NSData *)data;
+ (NSString *)encode:(id)data;
@end
