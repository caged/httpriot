//
//  ISAEditableTextFieldCell.h
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ISAEditableTextFieldCell : UITableViewCell {
    UILabel     *_labelField;
    UITextField *_valueField;
}
@property (nonatomic, retain) UILabel *labelField;
@property (nonatomic, retain) UITextField *valueField;

@end
