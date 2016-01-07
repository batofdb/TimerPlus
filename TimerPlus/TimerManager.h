//
//  TimerManager.h
//  TimerPlus
//
//  Created by Francis Bato on 1/6/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import <Parse/Parse.h>

@class User;
@class Timer;

@interface TimerManager : PFObject <PFSubclassing>


/******Activity Types:**********

 @0 - Message
 @1 - Like

 ********************************/

@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *content;
@property (nonatomic) User *toUser;
@property (nonatomic) User *fromUser;
@property Timer *timer;

+ (NSString *)parseClassName;
- (void)sendTimerToUser:(User *)toUser fromUser:(User *)fromUser withTimer:(Timer *)timer withMessage:(NSString *)message;
- (void)createTimerForUser:(User *)user withTimer:(Timer *)timer withMessage:(NSString *)message;

@end
