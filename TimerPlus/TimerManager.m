//
//  TimerManager.m
//  TimerPlus
//
//  Created by Francis Bato on 1/6/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager

@dynamic toUser;
@dynamic fromUser;
@dynamic content;
@dynamic type;
@dynamic timer;

+ (NSString *)parseClassName {
    return @"TimerManager";
}

+ (void)load {
    [self registerSubclass];
}


- (void)sendTimerToUser:(User *)toUser fromUser:(User *)fromUser withTimer:(Timer *)timer withMessage:(NSString *)message {
    self.toUser = toUser;
    self.fromUser = fromUser;
    self.timer = timer;
    self.type = @0;
    self.content = message;
}

- (void)createTimerForUser:(User *)user withTimer:(Timer *)timer withMessage:(NSString *)message {
    self.toUser = user;
    self.fromUser = nil;
    self.timer = timer;
    self.type = @0;
    self.content = message;
}

@end
