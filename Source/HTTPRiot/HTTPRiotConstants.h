/**
  Supported REST methods
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
 Supported formats
 */
typedef enum {
    /// JSON
    kHTTPRiotJSONFormat = 1,
    /// XML
    kHTTPRiotXMLFormat
} kHTTPRiotFormat;

#define HTTPRiotErrorDomain @"com.alternateidea.HTTPRiot.ErroDomain"