//
//  HTTPRiotFormatXML.m
//  HTTPRiot
//
//  Created by Justin Palmer on 2/8/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "HRFormatXML.h"
#import "AIXMLSerialization.h"

@implementation HRFormatXML
+ (NSString *)extension {
    return @"xml";
}

+ (NSString *)mimeType {
    return @"application/xml";
}

+ (id)decode:(NSData *)data {
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyXML error:nil];
    NSDictionary *dict = [doc toDictionary];
    [doc release];
    
    return dict;
}

+ (NSString *)encode:(id)data {
    NSAssert(true, @"XML Encoding is not supported.  Currently accepting patches");
    return nil;
}

@end
