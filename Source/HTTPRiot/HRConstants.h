/**
 * @file HRConstants.h Shared types and constants.
 */
 
/**
 * Supported REST methods.
 * @see HRRequestOperation
 */
typedef enum {
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
    HRDataFormatUnknown = -1,
    /// JSON Format
    HRDataFormatJSON,
    /// XML Format
    HRDataFormatXML
} HRDataFormat;

#define HTTPRiotErrorDomain @"com.alternateidea.HTTPRiot.ErroDomain"
#ifdef DEBUG
#define HTTPRIOT_DEBUG_REQUESTS 1
#else
#define HTTPRIOT_DEBUG_REQUESTS 0
#endif