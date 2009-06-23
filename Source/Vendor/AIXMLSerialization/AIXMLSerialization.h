#if TARGET_OS_IPHONE

#import "DDXML.h"

#ifndef NSXMLNode
#define NSXMLNode DDXMLNode
#endif
#ifndef NSXMLElement
#define NSXMLElement DDXMLElement
#endif
#ifndef NSXMLDocument
#define NSXMLDocument DDXMLDocument
#endif

#ifndef NSXMLNodeKind                                                   
#define NSXMLInvalidKind                 DDXMLInvalidKind              
#define NSXMLDocumentKind                DDXMLDocumentKind             
#define NSXMLElementKind                 DDXMLElementKind              
#define NSXMLAttributeKind               DDXMLAttributeKind            
#define NSXMLNamespaceKind               DDXMLNamespaceKind            
#define NSXMLProcessingInstructionKind   DDXMLProcessingInstructionKind
#define NSXMLCommentKind                 DDXMLCommentKind              
#define NSXMLTextKind                    DDXMLTextKind                 
#define NSXMLDTDKind                     DDXMLDTDKind                  
#define NSXMLEntityDeclarationKind       DDXMLEntityDeclarationKind    
#define NSXMLAttributeDeclarationKind    DDXMLAttributeDeclarationKind 
#define NSXMLElementDeclarationKind      DDXMLElementDeclarationKind   
#define NSXMLNotationDeclarationKind     DDXMLNotationDeclarationKind  

#define NSXMLNodeKind DDXMLNodeKind;
#endif

#ifndef NSXMLNodeOptionsNone
#define NSXMLNodeOptionsNone         DDXMLNodeOptionsNone        
#define NSXMLNodeExpandEmptyElement  DDXMLNodeExpandEmptyElement 
#define NSXMLNodeCompactEmptyElement DDXMLNodeCompactEmptyElement
#define NSXMLNodePrettyPrint         DDXMLNodePrettyPrint        
#endif

#ifndef NSXMLDocumentXMLKind
#define NSXMLDocumentXMLKind   DDXMLDocumentXMLKind 
#define NSXMLDocumentXHTMLKind DDXMLDocumentXHTMLKind
#define NSXMLDocumentHTMLKind  DDXMLDocumentHTMLKind
#define NSXMLDocumentTextKind  DDXMLDocumentTextKind

#define NSXMLDocumentContentKind DDXMLDocumentContentKind
#endif


#if TARGET_OS_IPHONE
enum {
    // Tidy
    NSXMLDocumentTidyHTML = 1 << 9,
    NSXMLDocumentTidyXML = 1 << 10,
    
    // Validate
    NSXMLDocumentValidate = 1 << 13,

    // Parse
    NSXMLDocumentXInclude = 1 << 16
};
#endif
#endif


#import "AIXMLDocumentSerialize.h"
#import "AIXMLElementSerialize.h"