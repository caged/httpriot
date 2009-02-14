// Using MiloBird's implementation on CocoaDevCentral
// http://www.cocoadev.com/index.pl?BaseSixtyFour/


@interface NSData (Base64)
- (NSString *)base64Encoding;
+ (id)dataWithBase64EncodedString:(NSString *)string;
@end
