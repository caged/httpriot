#include <openssl/bio.h>
#include <openssl/evp.h>

@interface NSData (Base64)
- (NSString *) encodeBase64;
- (NSString *) encodeBase64WithNewlines: (BOOL) encodeWithNewlines;
@end
