//
//  ISAPeopleDetailController.m
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "ISAPeopleDetailController.h"
#import "ISAEditableTextFieldCell.h"
#import "ISAAlertHelper.h"
#import <HTTPRiot/HTTPRiot.h>

@implementation ISAPeopleDetailController
@synthesize person = _person;


- (void)dealloc {
    [_saveButton release];
    [_person release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.tableView.allowsSelection = NO;
        _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    }
    return self;
}

- (void)save
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *cells = [[self.tableView visibleCells] retain];

    [params setObject:[[cells objectAtIndex:0] valueField].text forKey:@"name"];
    [params setObject:[[cells objectAtIndex:1] valueField].text forKey:@"email"];
    [params setObject:[[cells objectAtIndex:2] valueField].text forKey:@"address"];
    [params setObject:[[cells objectAtIndex:3] valueField].text forKey:@"telephone"];

    NSDictionary *bodyData = [NSDictionary dictionaryWithObjectsAndKeys:[params JSONRepresentation], @"body", nil];
    [HRRestModel putPath:[NSString stringWithFormat:@"/person/%@", [self.person valueForKey:@"id"]] withOptions:bodyData object:nil];
}


#pragma mark - HRResponseDelegate Methods
- (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)object {
    NSLog(@"RESPONSE:%@", response);
    ISAAlertWithMessage([error localizedDescription]);
}

- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object {
    [resource retain];
    [_person release];
    _person = resource;
    [self.tableView reloadData];
}

#pragma mark - Other
- (void)prepareCell:(ISAEditableTextFieldCell *)cell forIndexPath:(NSIndexPath *)ipath {
    NSInteger row = ipath.row;
    NSString *label = @"";
    NSString *value = @"";
    
    switch(row) {
        case 0:
            label = @"Name:";
            value = [self.person valueForKey:@"name"];
            break;
        case 1:
            label = @"Email:";
            value = [self.person valueForKey:@"email"];
            break;
        case 2:
            label = @"Address:";
            value = [self.person valueForKey:@"address"];
            break;
        case 3:
            label = @"Telephone:";
            value = [self.person valueForKey:@"telephone"];
            break;
        
    }
    
    cell.labelField.text = label;
    cell.valueField.text = value;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;

}



- (void)viewWillAppear:(BOOL)animated {        
    [HRRestModel setDelegate:self];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ISAEditableTextFieldCell *cell = (ISAEditableTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ISAEditableTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.valueField.delegate = self;
    }
    
    [self prepareCell:cell forIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Value Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = _saveButton;
}

@end

