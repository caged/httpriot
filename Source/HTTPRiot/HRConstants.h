/**
 * @file HRConstants.h Shared types and constants.
 */
 
/**
 * Supported REST methods.
 * @see HRRequestOperation
 */
typedef enum {
    /// Unknown
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
    /// Unknown
    HRDataFormatUnknown = -1,
    /// JSON Format
    HRDataFormatJSON,
    /// XML Format
    HRDataFormatXML
} HRDataFormat;

/// HTTPRiot's error domain
#define HTTPRiotErrorDomain @"com.labratrevenge.HTTPRiot.ErroDomain"

#ifdef DEBUG
/// Determines if request information should be printed to the console.
#define HTTPRIOT_DEBUG_REQUESTS 1
#else
/// Determines if request information should be printed to the console 
#define HTTPRIOT_DEBUG_REQUESTS 0
#endif