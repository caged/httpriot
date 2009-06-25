//
//  ISAPeopleTableViewController.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTTPRiot/HRResponseDelegate.h>

@interface ISAPeopleTableViewController : UITableViewController<HRResponseDelegate> {
    NSMutableArray *_people;
    NSIndexPath    *_indexPathOfItemToDelete;
    BOOL           _isDeleting;
}

@end
