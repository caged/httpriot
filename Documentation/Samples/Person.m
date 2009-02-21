@interface Twitter : HTTPriotRestModel {} @end


@implementation Tweet
- (void)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        // Setup your properties from the dictionary
    }
    
    return self;
}

+ (void)initialize
{
    [self setBaseURI:[NSURL URLWithString:@"http://twitter.com"]];
}

+ (id)publicTimeline
{
    NSMutableArray *people = [[[NSMutableArray alloc] init] autorelease];
    NSError *error = nil;
    NSArray *people = [self getPath:@"/statuses/public_timeline.json" withOptions:nil error:&error];
    for(NSDictionary *person in people)
    {
        Tweet *tw = [[self alloc] initWithDictionary:person];
        [people addObject:tw];
        [tw release];
    }
    
    return people;
}
@end


