/**
 * @file HTTPRiotConstants.h Shared types and constants.
 */
 
/**
 * Supported REST methods.
 * @see HTTPRiotRequest
 */
typedef enum {
    /// GET
    kHTTPRiotMethodGet = 1,
    /// POST
    kHTTPRiotMethodPost,
    /// PUT
    kHTTPRiotMethodPut,
    /// DELETE
    kHTTPRiotMethodDelete
} kHTTPRiotMethod;

/**
 Supported formats/formatters.
 @see HTTPRiotRestModel#setFormat
 */
typedef enum {
    /// JSON Format
    kHTTPRiotJSONFormat = 1,
    /// XML Format
    kHTTPRiotXMLFormat
} kHTTPRiotFormat;

#define HTTPRiotErrorDomain @"com.alternateidea.HTTPRiot.ErroDomain"