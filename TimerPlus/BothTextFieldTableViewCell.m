//
//  BothTextFieldTableViewCell.m
//  TimerPlus
//
//  Created by Francis Bato on 12/20/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "BothTextFieldTableViewCell.h"
#define SECONDSFIELD 0;
#define NAMEFIELD 1;

@implementation BothTextFieldTableViewCell

- (void)awakeFromNib {
    self.rightTextField.adjustsFontSizeToFitWidth = YES;
    self.rightTextField.textAlignment = NSTextAlignmentRight;
    self.rightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.rightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    self.rightTextField.tag = SECONDSFIELD;


    self.leftTextField.adjustsFontSizeToFitWidth = YES;
    self.leftTextField.textAlignment = NSTextAlignmentLeft;
    self.leftTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.leftTextField setKeyboardType:UIKeyboardTypeDefault];
    self.leftTextField.tag = NAMEFIELD;

    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
