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

- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object {
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

- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object { 
    if([error code] == -1004)
        ISAAlertWithMessage([NSString stringWithFormat:@"%@: Start the test server `ruby Source/Tests/Server/testserver.rb`", [error localizedDescription]]);
}

- (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error responseBody:(NSString *)string {
    ISAAlertWithMessage([error localizedDescription]);
}

- (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(HRResponse *)response object:(id)object {
    ISAAlertWithMessage([error localizedDescription]);
}

- (void)restConnection:(NSURLConnection *)connection didReceiveResponse:(HRResponse *)response object:(id)object {
    NSLog(@"RESPONSE STATUS WAS:%i", response.statusCode);
    NSLog(@"RESPONSE DATA WAS:%@", response.responseBody);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    
    [HRRestModel setDelegate:self];
    [HRRestModel getPath:@"/people" withOptions:nil object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}


#pragma mark Table view methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *person = [_people objectAtIndex:indexPath.row];
    
    _indexPathOfItemToDelete = indexPath;
    _isDeleting = YES;
    
    [HRRestModel deletePath:[NSString stringWithFormat:@"person/delete/%@", [person valueForKey:@"id"]] withOptions:nil object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
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

@end