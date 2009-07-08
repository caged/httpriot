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

+ (id)decode:(NSData *)data error:(NSError **)error {
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyXML error:error];
    if(error != nil) {
        NSLog(@"ERROR NOT NIL:%@", [parseError localizedDescription]);
        [doc release];
        return nil;
    }
    
    NSDictionary *dict = [doc toDictionary];
    [doc release];
    
    return dict;
}

+ (NSString *)encode:(id)data error:(NSError **)error {
    NSAssert(true, @"XML Encoding is not supported.  Currently accepting patches");
    return nil;
}

@end
