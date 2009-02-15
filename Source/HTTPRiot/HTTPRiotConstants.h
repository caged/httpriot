typedef enum {
    kHTTPRiotMethodGet = 1,
    kHTTPRiotMethodPost,
    kHTTPRiotMethodPut,
    kHTTPRiotMethodDelete
} kHTTPRiotMethod;

typedef enum {
    kHTTPRiotJSONFormat = 1,
    kHTTPRiotXMLFormat
} kHTTPRiotFormat;

#define HTTPRiotErrorDomain @"com.alternateidea.HTTPRiot.ErroDomain"