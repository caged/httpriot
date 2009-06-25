//
//  ISAAlertHelper.m
//  HTTPRiot
//
//  Created by Justin Palmer on 6/25/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//


void ISAAlertWithMessage(NSString *message)
{
	/* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iPhone Sample App" 
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}