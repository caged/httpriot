#include <openssl/bio.h>
#include <openssl/evp.h>

@interface NSString (Base64)
- (NSData *) decodeBase64;
- (NSData *) decodeBase64WithNewlines: (BOOL) encodedWithNewlines;
@end
