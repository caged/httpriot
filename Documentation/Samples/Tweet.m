@implementation Tweet
@synthesize screenName;
@synthesize name;
@synthesize text;
@synthesize location;

// Set default options here
+ (void)initialize {
    [self setDelegate:self];
    [self setBaseURL:[NSURL URLWithString:@"http://twitter.com"]];
}

- (void)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {
        [self setScreenName:[dict valueForKeyPath:@"user.screen_name"]];
        [self setName:[dict valueForKeyPath:@"user.name"]];
        [self setLocation:[dict valueForKeyPath:@"user.location"]];
        [self setText:[dict valueForKey:@"text"]];
    }
    
    return self;
}

+ (id)timelineForUser:(NSString *)user delegate:(id)delegate {
    NSDictionary *params = [NSDictionary dictionaryWithObject:user forKey:@"screen_name"];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    [self getPath:@"/statuses/user_timeline.json" withOptions:opts object:delegate];
}

+ (id)publicTimelineWithDelegate:(id)delegate {
    [self getPath:@"/statuses/public_timeline.json" withOptions:nil object:delegate];
}

#pragma mark - HRRequestOperation Delegates
+ (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object {
    // Handle connection errors.  Failures to connect to the server, etc.
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)object {
    // Handle invalid responses, 404, 500, etc.
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error responseBody:(NSString *)string {
    // Request was successful, but couldn't parse the data returned by the server. 
}

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource  object:(id)object {
    NSMutableArray *tweets = [[[NSMutableArray alloc] init] autorelease];
    
    for(id item in resource) {
        [tweets addItem:[[Tweet alloc] initWithDictionary:item]];
    }
    
    [object performSelector:@selector(tweetsLoaded:) withObject:tweets];
}
@end


