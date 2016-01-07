//
//  Exercise.h
//  TimerPlus
//
//  Created by Francis Bato on 12/4/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class User;

@interface Exercise : PFObject <PFSubclassing>

@property NSString *name;
@property NSInteger seconds;
@property (nonatomic) User *createdBy;

@end
