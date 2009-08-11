/**
 * @file HRGlobal.h Shared types and constants.
 */
#import <Foundation/Foundation.h>

extern NSString *kHRClassAttributesDelegateKey;
extern NSString *kHRClassAttributesBaseURLKey;
extern NSString *kHRClassAttributesHeadersKey;
extern NSString *kHRClassAttributesBasicAuthKey;
extern NSString *kHRClassAttributesUsernameKey;
extern NSString *kHRClassAttributesPasswordKey;
extern NSString *kHRClassAttributesFormatKey;
extern NSString *kHRClassAttributesDefaultParamsKey;
extern NSString *kHRClassAttributesParamsKey;
extern NSString *kHRClassAttributesBodyKey;

 
/**
 * Supported REST methods.
 * @see HRRequestOperation
 */
typedef enum {
    /// Unknown [NOT USED]
    HRRequestMethodUnknown = -1,
    /// GET
    HRRequestMethodGet,
    /// POST
    HRRequestMethodPost,
    /// PUT
    HRRequestMethodPut,
    /// DELETE
    HRRequestMethodDelete
} HRRequestMethod;

/**
 Supported formats.
 @see HRRestModel#setFormat
 */
typedef enum {
    /// Unknown [NOT USED]
    HRDataFormatUnknown = -1,
    /// JSON Format
    HRDataFormatJSON,
    /// XML Format
    HRDataFormatXML
} HRDataFormat;

/// HTTPRiot's error domain
#define HTTPRiotErrorDomain @"com.labratrevenge.HTTPRiot.ErroDomain"

#ifdef DEBUG
/// Logging Helper
#define HRLOG NSLog
#else
/// Logging Helper
#define HRLOG    
#endif