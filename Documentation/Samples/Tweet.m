@implementation Tweet
@synthesize screenName;
@synthesize name;
@synthesize text;
@synthesize location;

// Set default options here
+ (void)initialize {
    [self setDelegate:self];
    [self setBaseURI:[NSURL URLWithString:@"http://twitter.com"]];
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

+ (id)timelineForUser:(NSString *)user
{
    NSDictionary *targetAction = [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", NSStringFromSelector(sel), @"selector", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObject:user forKey:@"screen_name"];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    [self getPath:@"/statuses/user_timeline.json" withOptions:opts];
}

+ (id)publicTimeline {
    [self getPath:@"/statuses/public_timeline.json" withOptions:nil];
}

#pragma mark - HRRequestOperation Delegates
+ (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Handle connection errors.  Failures to connect to the server, etc.
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response {
    // Handle invalid responses, 404, 500, etc.
}

+ (void)restConnection:(NSURLConnection *)connection didFinishReturningResource:(id)resource {

}

+ (void)tweetsLoaded:(NSDictionary *)info
{
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    NSError *error = [info valueForKey:@"error"];
    NSArray *results = [info valueForKey:@"results"];
    id obj = [info valueForKey:@"object"];
    
    if(error == nil)
    {
        for(id item in results)
        {
            [tweets addItem:[[Tweet alloc] initWithDictionary:item]];
        }
    }
    
    id target = [obj valueForKey:@"target"];
    SEL selector = NSSelectorFromString([obj valueForKey:@"selector"]);
    
    if([target respondsToSelector:selector])
        [target performSelector:selector withObject:tweets withObject:error];
}
@end


