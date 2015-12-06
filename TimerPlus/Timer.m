//
//  Timer.m
//  TimerPlus
//
//  Created by Francis Bato on 11/28/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "Timer.h"

@implementation Timer

- (instancetype) init {
    self = [super init];
    if (self) {
        self.name = @"New Timer";
        self.sets = 0;
        self.exercises = [NSMutableArray new];
        self.interval_between_reps = 0;
        self.interval_between_sets = 0;
        self.warmup = 0;
        self.cooldown = 0;
    }

    return self;
}

@end
