#import "NSString+URI.h"

@implementation NSString (URI)
- (NSString *)stringByPreparingForURL
{
    NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(
    	NULL, (CFStringRef) self, (CFStringRef) @"%+#", NULL,
    	CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));                                            
    return result;
}
@end
