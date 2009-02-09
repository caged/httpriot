//
//  NSString.m
//  LampLight
//
//  Created by Justin Palmer on 12/23/08.
//  Copyright 2008 Alternateidea. All rights reserved.
//

#import "NSString+Base64.h"


@implementation NSString (Base64)

- (NSData *) decodeBase64;
{
    return [self decodeBase64WithNewlines: YES];
}

- (NSData *) decodeBase64WithNewlines: (BOOL) encodedWithNewlines;
{
    // Create a memory buffer containing Base64 encoded string data
    BIO * mem = BIO_new_mem_buf((void *) [self cStringUsingEncoding:NSUTF8StringEncoding], [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    // Push a Base64 filter so that reading from the buffer decodes it
    BIO * b64 = BIO_new(BIO_f_base64());
    if (!encodedWithNewlines)
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    mem = BIO_push(b64, mem);
    
    // Decode into an NSMutableData
    NSMutableData * data = [NSMutableData data];
    char inbuf[512];
    int inlen;
    while ((inlen = BIO_read(mem, inbuf, sizeof(inbuf))) > 0)
        [data appendBytes: inbuf length: inlen];
    
    // Clean up and go home
    BIO_free_all(mem);
    return data;
}

@end
