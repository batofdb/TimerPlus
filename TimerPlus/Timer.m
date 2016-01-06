//
//  Timer.m
//  TimerPlus
//
//  Created by Francis Bato on 11/28/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import "Timer.h"
#import "Exercise.h"

@implementation Timer

@dynamic sets;
@dynamic name;
@dynamic exercises;
@dynamic interval_between_reps;
@dynamic interval_between_sets;
@dynamic warmup;
@dynamic cooldown;
@dynamic totalTime;

+ (NSString *)parseClassName {
    return @"Timer";
}

+ (void)load {
    [self registerSubclass];
}

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

- (NSString *)convertExercisesToString:(NSMutableArray *)inputArray {
    NSString *outStr = [NSString stringWithFormat:@""];

    for (Exercise *exercise in inputArray) {
        NSString *str;
        if ([inputArray.lastObject isEqual:exercise]) {
            str = [NSString stringWithFormat:@"%@:%li",exercise.name,exercise.seconds];
        } else {
            str = [NSString stringWithFormat:@"%@:%li,",exercise.name,exercise.seconds];
        }

        outStr = [outStr stringByAppendingString:str];
    }

    NSLog(@"%@",outStr);

    return outStr;
}

+ (NSArray *)convertStringToExercises:(NSString *)inputStr {
    NSArray *array = [inputStr componentsSeparatedByString:@","];
    NSMutableArray *outputArray = [NSMutableArray new];

    for (int i=0;i<array.count;i++) {
        NSArray *rawExercise = [array[i] componentsSeparatedByString:@":"];
        Exercise *exercise = [Exercise new];
        exercise.name = rawExercise.firstObject;
        exercise.seconds = [rawExercise.lastObject integerValue];

        [outputArray addObject:exercise];
    }

    NSLog(@"output exercise array");
    return [outputArray copy];
}

@end
