//
//  iPhoneSampleAppAppDelegate.m
//  iPhoneSampleApp
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright LabratRevenge LLC. 2009. All rights reserved.
//

#import "iPhoneSampleAppDelegate.h"
#import "ISAPeopleTableViewController.h"

@implementation iPhoneSampleAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch  
    ISAPeopleTableViewController *peopleController = [[[ISAPeopleTableViewController alloc] init] autorelease];
    navigationController.viewControllers = [NSArray arrayWithObjects:peopleController, nil];
    
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

