//
//  RightTextFieldTableViewCell.h
//  TimerPlus
//
//  Created by Francis Bato on 12/20/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@end
