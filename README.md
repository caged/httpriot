# HTTPRiot - Easily Consume REST Services

HTTPRiot is a simple HTTP library that works on the iPhone and Cocoa Apps.  It tries to abstract as much as possible 
in the beginning.  This means you don't spend a lot of time up front setting things up and staying on a golden path, but 
this also means it makes no assumptions about the data returned.  It will convert JSON and XML automatically to NSDictionary or NSArray objects, 
allowing you to do what you want to with the data, but it's up to you to create your own models if you wish.

It offers a lot of flexibility with the data returned, but the tradeoff is that you must know what to do with 
the data returned because if you initiate two requests from one model both will be routed through the same 
delegate methods that handle responses/errors/etc.

## Documentation and Samples:

* [Online Documentation](http://labratrevenge.com/httpriot)
* [Support & Community](http://justin.tenderapp.com)
* Sample app and server included with the source

## Quick Examples
    // GET
    [model getPath:@"/foo/bar.json" withOptions:nil object:nil];

    // POST
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[obj JSONRepresentation] forKey:@"body"];
    [model postPath:@"/foo" withOptions:params object:nil];

    // PUT
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[obj JSONRepresentation] forKey:@"body"];
    [model putPath:@"/foo/1" withOptions:params object:nil];

    // DELETE
    [model deletePath:@"/foo/1" withOptions:nil object:nil];

## Similar Projects
HTTPRiot was inspired by the <a href="http://github.com/jnunemaker/httparty/tree/master">httparty</a> Ruby library.
There are also numerous other HTTP libraries for Cocoa:

* [ASIHTTPRequest](http://github.com/pokeb/asi-http-request/tree/master)
* [Three20's TTURLRequest](http://github.com/joehewitt/three20/tree/master)
* [ObjectiveResource](http://github.com/yfactorial/objectiveresource/tree/master)
