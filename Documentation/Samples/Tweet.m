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
        // Setup more of your properties from the dictionary
    }
    
    return self;
}

// Set default options here
+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://twitter.com"]];
}

+ (id)publicTimeline
{
    NSError *error = nil;
    NSArray *people = [self getPath:@"/statuses/public_timeline.json" withOptions:nil error:&error];
    for(NSDictionary *person in people)
    {
        Tweet *tw = [[self alloc] initWithDictionary:person];
        [people addObject:tw];
        [tw release];
    }
    // Returns a collection of <Tweet> objects.
    return people;
}
@end


