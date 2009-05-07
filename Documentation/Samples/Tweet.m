@implementation Tweet
@synthesize screenName;
@synthesize name;
@synthesize text;
@synthesize location;

- (void)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setScreenName:[dict valueForKeyPath:@"user.screen_name"]];
        [self setName:[dict valueForKeyPath:@"user.name"]];
        [self setLocation:[dict valueForKeyPath:@"user.location"]];
        [self setText:[dict valueForKey:@"text"]];
    }
    
    return self;
}

// Set default options here
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://twitter.com"]];
}

+ (id)timelineForUser:(NSString *)user target:(id)target selector:(SEL)sel
{
    NSDictionary *targetAction = [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", NSStringFromSelector(sel), @"selector", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObject:user forKey:@"screen_name"];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:params forKey:@"params"];
    
    [self getPath:@"/statuses/user_timeline.json" withOptions:opts target:self selector:@selector(tweetsLoaded:) object:targetAction];
}

+ (id)publicTimelineWithTarget:(id)target selector:(SEL)sel
{
    // We could just use the controller calling this method as the target and selector, but instead we want to 
    // to reuse a method to initialize an array of tweets so we pass use a callback in the model to initialize 
    // the tweets and pass the additional target and selector as the `object` so we can use it later after the 
    // tweets have been initialized. 
    NSDictionary *targetAction = [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", NSStringFromSelector(sel), @"selector", nil];
    [self getPath:@"/statuses/public_timeline.json" target:self selector:@selector(tweetsLoaded:) object:targetAction];
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


