    //
//  SAApplicationDelegate.m
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import "SAApplicationDelegate.h"
#import <HTTPRiot/HTTPRiot.h>
#import "JSON.h"

@interface SAApplicationDelegate()
@property (retain) NSMutableArray *people;
@end

@implementation SAApplicationDelegate
@synthesize arrayController, people;

- (id)init
{
    self = [super init];
    if(self)
    {
        // For this sample app we're using HRRestModel directly, but you can
        // subclass it if you want your models to have unique attributes.
        [HRRestModel setBaseURI:[NSURL URLWithString:@"http://localhost:4567"]];
        
        self.people = [[NSMutableArray alloc] init];
        arrayController = [[NSArrayController alloc] init];
        [arrayController setSortDescriptors:[NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                                   ascending:YES
                                                                                                    selector:@selector(caseInsensitiveCompare:)] autorelease], nil]];
        [arrayController bind:@"contentArray" toObject:self withKeyPath:@"people" options:nil];
        
    }
    
    return self;
}

- (void)dealloc
{
    [people release];
    [arrayController release];
    [super dealloc];
}

- (void)awakeFromNib
{   
    tableView.delegate = self;                                                                                  
    [HRRestModel getPath:@"/pesople" target:self selector:@selector(peopleLoaded:) object:@"FOOBAR"];
}

- (IBAction)addPerson:(id)sender
{
    NSMutableDictionary *placeholder = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        @"name", @"name",
        @"foo@email.com", @"email", 
        @"1234567890", @"telephone",
        @"101 Cherry Lane", @"address",
        nil];
    [arrayController addObject:placeholder];
}

- (IBAction)removePerson:(id)sender;
{
    NSMutableDictionary *person = [[arrayController selectedObjects] objectAtIndex:0];
    NSInteger personID = [[person valueForKey:@"id"] intValue];
    NSString *path = [NSString stringWithFormat:@"/person/delete/%i", personID];
    
    [HRRestModel deletePath:path
                           target:self
                         selector:@selector(personRemoved:)
                           object:[NSNumber numberWithInt:[arrayController selectionIndex]]];
}

- (void)objectDidEndEditing:(id)editor
{
    NSMutableDictionary *person = [[editor selectedObjects] objectAtIndex:0];
    
    // New Record
    if([person valueForKey:@"id"] == nil)
    {
    
        NSLog(@"ID WAS NIL:%@", person);
        NSString *json = [person JSONRepresentation];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:json forKey:@"body"];
    
        [HRRestModel postPath:@"/person" withOptions:opts target:self selector:@selector(personSaved:)];
    }
    
    // Editing existing record
    else
    {
        NSInteger personID = [[person valueForKey:@"id"] intValue];
        [person removeObjectsForKeys:[NSArray arrayWithObjects:@"created_at", @"id", nil]];
        
        NSString *json = [person JSONRepresentation];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:json forKey:@"body"];
        NSString *path = [NSString stringWithFormat:@"/person/%i", personID];
    
        [HRRestModel putPath:path
                       withOptions:opts
                            target:self
                          selector:@selector(personSaved:)];
    }
}

#pragma mark - HTTPRiot Callbacks

/**
 * dict contains 'response', 'results' and 'error'
 */
- (void)peopleLoaded:(NSDictionary *)info
{
    NSError *error = [info valueForKey:@"error"];
    
    if(error == nil)
    {
        NSHTTPURLResponse *response = [info valueForKey:@"response"];
        NSLog(@"RESPONSE HEADERS:%@", [response allHeaderFields]);
        id results = [info valueForKey:@"results"];
        // Set the people property to the results we got from the server
        [self.people addObjectsFromArray:results];
        
        // Now we bind the table columns to specific keys in the dictionary.  
        [[tableView tableColumnWithIdentifier:@"name"] bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.name" options:nil];
        [[tableView tableColumnWithIdentifier:@"email"] bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.email" options:nil];
        [[tableView tableColumnWithIdentifier:@"phone"] bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.telephone" options:nil];
        [[tableView tableColumnWithIdentifier:@"address"] bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.address" options:nil];        
    
        // Sort it
        [arrayController setSortDescriptors:[NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                                   ascending:YES
                                                                                                  selector:@selector(caseInsensitiveCompare:)] autorelease], nil]];
    }
    else
    {
        NSString *serverPath = [[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/../../.."] stringByStandardizingPath];
        serverPath = [serverPath stringByAppendingString:@"/Source/Tests/Server/testserver.rb"];
        NSLog(@"Failed to get resource:%@", [[error userInfo] valueForKey:NSErrorFailingURLStringKey]);
        NSLog(@"You likely have not started the test server.  Run: `ruby %@`", serverPath);
        
        [NSApp presentError:error];
    }
}

- (void)personSaved:(NSDictionary *)info
{
    NSError *error = [info valueForKey:@"error"];
    id results = [info valueForKey:@"results"];
    
    if(error == nil)
    {
        NSHTTPURLResponse *response = [info valueForKey:@"response"];
        NSLog(@"RESPONSE HEADERS:%@", [response allHeaderFields]);
        NSLog(@"RESULTS:%@", results);
    }
}

- (void)personRemoved:(NSDictionary *)info
{
    NSError *error = [info valueForKey:@"error"];
    id results = [info valueForKey:@"results"];

    if(error == nil)
    {
        NSHTTPURLResponse *response = [info valueForKey:@"response"];
        NSLog(@"RESPONSE HEADERS:%@", [response allHeaderFields]);
        
        NSInteger idx = [arrayController selectionIndex];
        [arrayController removeObjectAtArrangedObjectIndex:idx];
    }
    else
    {
        [NSApp presentError:error];
    }
}

@end


#pragma mark - Pretty up the window
// Just tossing this here to add a bottom region to the window for some buttons
@implementation SAWindow
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation
{
    self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
    if(self)
    {
        [self setContentBorderThickness:44.0 forEdge:NSMinYEdge];
    }
    
    return self;
}
@end