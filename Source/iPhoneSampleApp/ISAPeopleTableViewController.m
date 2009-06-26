//
//  ISAPeopleTableViewController.m
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "ISAPeopleTableViewController.h"
#import "ISAPeopleDetailController.h"
#import "ISAAlertHelper.h"
#import <HTTPRiot/HTTPRiot.h>

@implementation ISAPeopleTableViewController

- (void)dealloc {
    _isDeleting = nil;
    _indexPathOfItemToDelete = nil;
    [_people release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
        _people = [[NSMutableArray alloc] init];
        _indexPathOfItemToDelete = nil;
        _isDeleting = NO;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"People";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)restConnection:(NSURLConnection *)connection didFinishReturningResource:(id)resource {
    if(_isDeleting) {
        [_people removeObjectAtIndex:_indexPathOfItemToDelete.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:_indexPathOfItemToDelete, nil] withRowAnimation:YES];
        [self.tableView endUpdates];
        [self.tableView reloadData];
        _isDeleting = false;
        _indexPathOfItemToDelete = nil;
    } else {
        [_people removeAllObjects];
        [_people addObjectsFromArray:resource];
        [self.tableView reloadData];
    }
}

- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error { 
    if([error code] == -1004)
        ISAAlertWithMessage([NSString stringWithFormat:@"%@: Start the test server `ruby Source/Tests/Server/testserver.rb`", [error localizedDescription]]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    
    [HRRestModel setDelegate:self];
    [HRRestModel getPath:@"/people" withOptions:nil];
}

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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *person = [_people objectAtIndex:indexPath.row];
    
    _indexPathOfItemToDelete = indexPath;
    _isDeleting = YES;
    
    [HRRestModel deletePath:[NSString stringWithFormat:@"person/delete/%@", [person valueForKey:@"id"]] withOptions:nil];
}

// - (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//     return UITableViewCellAccessoryDisclosureIndicator;
// }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_people count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Set up the cell...
    cell.textLabel.text = [[_people objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    ISAPeopleDetailController *peopleDetailController = [[ISAPeopleDetailController alloc] init];
    peopleDetailController.person = [_people objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:peopleDetailController animated:YES];
    [peopleDetailController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end

