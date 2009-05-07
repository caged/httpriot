//
//  SAApplicationDelegate.h
//  HTTPRiot
//
//  Created by Justin Palmer on 1/30/09.
//  Copyright 2009 Alternateidea. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SAApplicationDelegate : NSObject {
    NSMutableArray *people;
    NSArrayController *arrayController;
    IBOutlet NSTableView *tableView;
    IBOutlet NSButton *addButton;
    IBOutlet NSButton *removeButton;
}

@property (retain, readonly) NSMutableArray *people;
@property (retain, readonly) NSArrayController *arrayController;

- (IBAction)addPerson:(id)sender;
- (IBAction)removePerson:(id)sender;
@end

@interface SAWindow : NSWindow {} @end