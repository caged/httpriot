//
//  ISAPeopleDetailController.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTTPRiot/HRResponseDelegate.h>

@interface ISAPeopleDetailController : UITableViewController<UITextFieldDelegate, HRResponseDelegate> {
    NSDictionary *_person;
    UIBarButtonItem     *_saveButton;
}

@property (nonatomic, retain) NSDictionary *person;

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)ipath;
@end
