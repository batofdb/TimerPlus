//
//  Exercise.m
//  TimerPlus
//
//  Created by Francis Bato on 12/4/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "Exercise.h"

@implementation Exercise

@dynamic name;
@dynamic seconds;

+ (NSString *)parseClassName {
    return @"Exercise";
}

+ (void)load {
    [self registerSubclass];
}
@end
