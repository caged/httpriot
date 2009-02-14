// Using implementation from Dave Dirbin 
// http://www.cocoadev.com/index.pl?BaseSixtyFour
// http://www.dribin.org/dave/software/
//
// Released under an MIT License
#include <openssl/bio.h>
#include <openssl/evp.h>

@interface NSString (Base64)
- (NSData *) decodeBase64;
- (NSData *) decodeBase64WithNewlines: (BOOL) encodedWithNewlines;
@end
