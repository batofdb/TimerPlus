//
//  BothTextFieldTableViewCell.h
//  TimerPlus
//
//  Created by Francis Bato on 12/20/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BothTextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@end
