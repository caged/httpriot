/**
 * @file HTTPRiotConstants.h Shared types and constants.
 */
 
/**
 * Supported REST methods.
 * @see HTTPRiotRequestOperation
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
 @see HTTPRiotRestModel#setFormat
 */
typedef enum {
    HRFormatUnknown = -1,
    /// JSON Format
    HRFormatJSON,
    /// XML Format
    HRFormatXML
} HRFormat;

#define HTTPRiotErrorDomain @"com.alternateidea.HTTPRiot.ErroDomain"
#ifdef DEBUG
#define HTTPRIOT_DEBUG_REQUESTS 1
#else
#define HTTPRIOT_DEBUG_REQUESTS 0
#endif