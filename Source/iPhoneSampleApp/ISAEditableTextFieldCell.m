//
//  ISAEditableTextField.m
//  HTTPRiot
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright 2009 LabratRevenge LLC.. All rights reserved.
//

#import "ISAEditableTextFieldCell.h"


@implementation ISAEditableTextFieldCell
@synthesize labelField = _labelField;
@synthesize valueField = _valueField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _labelField = [[UILabel alloc] init];
        _labelField.font = [UIFont boldSystemFontOfSize:12.0];
        _labelField.textAlignment = UITextAlignmentRight;
        _labelField.textColor = [UIColor grayColor];
        
        _valueField = [[UITextField alloc] init];
        _valueField.font = [UIFont systemFontOfSize:14.0];
        _valueField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valueField.keyboardType = UIKeyboardTypeAlphabet;
        _valueField.returnKeyType = UIReturnKeyDone;
        
        [self.contentView addSubview:_labelField];
        [self.contentView addSubview:_valueField];
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect rect = self.contentView.frame;
    _labelField.frame = CGRectMake(rect.origin.x + 20, rect.origin.y + 10,70,20);
    _valueField.frame = CGRectMake(100,rect.origin.y + 10,200,20);
}


- (void)dealloc {
    [_labelField release];
    [_valueField release];
    [super dealloc];
}


@end
