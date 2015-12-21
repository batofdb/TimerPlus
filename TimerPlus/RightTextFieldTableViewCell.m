//
//  RightTextFieldTableViewCell.m
//  TimerPlus
//
//  Created by Francis Bato on 12/20/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "RightTextFieldTableViewCell.h"

#define SECONDSFIELD 0;
#define NAMEFIELD 1;

@interface RightTextFieldTableViewCell() <UITextFieldDelegate>



@end

@implementation RightTextFieldTableViewCell

- (void)awakeFromNib {
    self.rightTextField.adjustsFontSizeToFitWidth = YES;
    self.rightTextField.textAlignment = NSTextAlignmentRight;
    self.rightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.rightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    self.rightTextField.tag = SECONDSFIELD;

    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
